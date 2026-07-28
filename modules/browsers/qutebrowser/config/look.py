import json
import os
import weakref

from qutebrowser.keyinput import modeman
from qutebrowser.utils import usertypes, objreg
from qutebrowser.qt.core import QProcess, QTimer
from qutebrowser.config import config as qbconfig
from qutebrowser.mainwindow import mainwindow
from qutebrowser.mainwindow.statusbar import bar


# --------------------------------------------------------------------- config

BORDER_WIDTH = 8

MODE_COLORS = {
    usertypes.KeyMode.insert:      'colors.statusbar.insert.bg',
    usertypes.KeyMode.command:     'colors.statusbar.command.bg',
    usertypes.KeyMode.hint:        'colors.hints.bg',
    usertypes.KeyMode.passthrough: 'colors.statusbar.passthrough.bg',
    usertypes.KeyMode.caret:       'colors.statusbar.caret.bg',
}

HIDDEN_MODES = {
    usertypes.KeyMode.hint,
    usertypes.KeyMode.insert,
    usertypes.KeyMode.passthrough,
}

# Delay (ms) before each `hyprctl clients` attempt.  Tight at the start so the
# window is claimed as soon as it maps, backing off in case something is wrong.
_RESOLVE_DELAYS = (0, 20, 40, 70, 120, 200, 350, 600, 1000, 1600, 2500)

_PID = os.getpid()
_PROCS = set()  # keeps QProcess objects alive until they finish


# ---------------------------------------------------------------------- color

def precompensate(hex_str):
    s = hex_str.lstrip('#')
    if len(s) == 3:
        s = ''.join(ch * 2 for ch in s)
    if len(s) != 6:
        raise ValueError(f"expected 3- or 6-digit hex, got {hex_str!r}")
    out = []
    for i in (0, 2, 4):
        c = int(s[i:i + 2], 16) / 255
        lin = c ** 2.2
        v = 12.92 * lin if lin <= 0.0031308 else 1.055 * lin ** (1 / 2.4) - 0.055
        out.append(max(0, min(255, round(v * 255))))
    return "".join(f"{v:02X}" for v in out)


# ----------------------------------------------------------- address resolving

def _window(win_id):
    try:
        return objreg.get('main-window', scope='window', window=win_id)
    except KeyError:
        return None


def _claimed():
    """Addresses already owned by a live MainWindow."""
    out = set()
    for win_id in list(objreg.window_registry):
        mw = _window(win_id)
        if mw is None:
            continue
        addr = getattr(mw, '_hypr_addr', None)
        if addr:
            out.add(addr)
    return out


def _own_clients(raw):
    try:
        clients = json.loads(raw.decode())
    except (ValueError, UnicodeDecodeError):
        return []
    return [c for c in clients if c.get('pid') == _PID and c.get('address')]


def _resolve(mw):
    """Discover mw's Hyprland address and cache it as mw._hypr_addr."""
    if getattr(mw, '_hypr_addr', None) or getattr(mw, '_hypr_resolving', False):
        return
    mw._hypr_resolving = True

    marker = f"qbhypr-{_PID}-{mw.win_id}"
    ref = weakref.ref(mw)
    st = {'marker': False, 'saved': None}

    def _arm_marker():
        """Fallback for ambiguity: stamp a unique title, re-stamping if
        qutebrowser overwrites it."""
        w = ref()
        if w is None or w.windowTitle() == marker:
            return
        st['saved'] = w.windowTitle()
        st['marker'] = True
        w.setWindowTitle(marker)

    def _disarm_marker():
        w = ref()
        if w is not None and st['marker'] and w.windowTitle() == marker:
            w.setWindowTitle(st['saved'])

    def _claim(addr):
        w = ref()
        if w is None:
            return
        w._hypr_addr = addr
        w._hypr_resolving = False
        _disarm_marker()
        pending = getattr(w, '_hypr_pending', None)
        w._hypr_pending = None
        if pending is not None:
            _apply(pending, w)

    def _give_up():
        w = ref()
        if w is not None:
            w._hypr_resolving = False
            w._hypr_pending = None
        _disarm_marker()

    def _attempt(i):
        w = ref()
        if w is None or getattr(w, '_hypr_addr', None):
            return

        proc = QProcess()
        _PROCS.add(proc)
        done = []

        def _retry():
            if i + 1 < len(_RESOLVE_DELAYS):
                QTimer.singleShot(_RESOLVE_DELAYS[i + 1], lambda: _attempt(i + 1))
            else:
                _give_up()

        def _next(clients):
            if done:
                return
            done.append(True)
            _PROCS.discard(proc)
            proc.deleteLater()
            if ref() is None:
                return

            # If a marker is armed, trust it over elimination.
            if st['marker']:
                for c in clients:
                    if marker in (c.get('title'), c.get('initialTitle')):
                        _claim(c['address'])
                        return
                _arm_marker()
                _retry()
                return

            candidates = [c['address'] for c in clients
                          if c['address'] not in _claimed()]
            if len(candidates) == 1:
                _claim(candidates[0])
            else:
                # 0: not mapped yet, just wait.
                # >1: two windows unresolved at once, disambiguate by title.
                if len(candidates) > 1:
                    _arm_marker()
                _retry()

        proc.finished.connect(
            lambda *_: _next(_own_clients(bytes(proc.readAllStandardOutput()))))
        proc.errorOccurred.connect(lambda *_: _next([]))
        proc.start("hyprctl", ["-j", "clients"])

    QTimer.singleShot(_RESOLVE_DELAYS[0], lambda: _attempt(0))


def _forget_all():
    """Drop every cached address; call after a Hyprland restart."""
    for win_id in list(objreg.window_registry):
        mw = _window(win_id)
        if mw is not None:
            mw._hypr_addr = None
            mw._hypr_resolving = False


# -------------------------------------------------------------------- dispatch

def _set_props(mw, *pairs):
    addr = getattr(mw, '_hypr_addr', None)
    if addr is None:
        return
    cmds = " ; ".join(
        f"dispatch hl.dsp.window.set_prop({{prop=[[{p}]],value={v},window=[[address:{addr}]]}})"
        for p, v in pairs
    )
    QProcess.startDetached("hyprctl", ["--batch", cmds])


def _apply(mode, mw):
    if mw is None:
        return
    if getattr(mw, '_hypr_addr', None) is None:
        # Not resolved yet: remember what we wanted and replay it once we know
        # where to send it.
        mw._hypr_pending = mode
        _resolve(mw)
        return

    color_var = MODE_COLORS.get(mode)
    if color_var is None:
        _set_props(mw, ("border_size", 0))
        return
    try:
        color = precompensate(qbconfig.instance.get(color_var))
    except ValueError:
        _set_props(mw, ("border_size", 0))
        return
    _set_props(
        mw,
        ("active_border_color", f"[[rgb({color})]]"),
        ("inactive_border_color", f"[[rgb({color})]]"),
        ("border_size", BORDER_WIDTH),
    )


# ------------------------------------------------------------------- statusbar

_sb_orig = getattr(bar.StatusBar.maybe_hide, '_hypr_orig', bar.StatusBar.maybe_hide)


def _patched_maybe_hide(self):
    _sb_orig(self)
    if qbconfig.val.statusbar.show != 'in-mode':
        return
    try:
        mm = modeman.instance(self._win_id)
    except modeman.UnavailableError:
        return
    if mm.mode in HIDDEN_MODES:
        self.hide()


_patched_maybe_hide._hypr_orig = _sb_orig
bar.StatusBar.maybe_hide = _patched_maybe_hide


def _refresh_bar(win_id):
    def _do():
        mw = _window(win_id)
        if mw is not None:
            mw.status.maybe_hide()
    QTimer.singleShot(0, _do)


# ---------------------------------------------------------------------- hooks

_mw_orig = getattr(mainwindow.MainWindow.__init__, '_hypr_orig',
                   mainwindow.MainWindow.__init__)


def _patched_mw_init(self, *args, **kwargs):
    _mw_orig(self, *args, **kwargs)
    _resolve(self)


_patched_mw_init._hypr_orig = _mw_orig
mainwindow.MainWindow.__init__ = _patched_mw_init


_mm_orig = getattr(modeman.ModeManager.__init__, '_hypr_orig',
                   modeman.ModeManager.__init__)


def _patched_mm_init(self, win_id, parent=None):
    _mm_orig(self, win_id, parent)

    def _on_mode(mode):
        _apply(mode, _window(win_id))
        _refresh_bar(win_id)

    self.entered.connect(lambda mode, *_: _on_mode(mode))
    self.left.connect(lambda *_: _on_mode(usertypes.KeyMode.normal))


_patched_mm_init._hypr_orig = _mm_orig
modeman.ModeManager.__init__ = _patched_mm_init


# ------------------------------------------------------------------ bootstrap

def _bootstrap():
    for win_id in list(objreg.window_registry):
        _refresh_bar(win_id)
        mw = _window(win_id)
        if mw is None:
            continue
        try:
            mode = modeman.instance(win_id).mode
        except modeman.UnavailableError:
            mode = usertypes.KeyMode.normal
        _apply(mode, mw)


QTimer.singleShot(0, _bootstrap)
