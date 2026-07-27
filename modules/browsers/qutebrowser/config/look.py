from qutebrowser.keyinput import modeman
from qutebrowser.utils import usertypes, objreg
from qutebrowser.qt.core import QProcess, QTimer
from qutebrowser.config import config as qbconfig
from qutebrowser.mainwindow.statusbar import bar

def precompensate(hex_str):
    s = hex_str.lstrip('#')
    if len(s) == 3:
        s = ''.join(ch * 2 for ch in s)
    if len(s) != 6:
        raise ValueError(f"expected 3- or 6-digit hex, got {hex_str!r}")
    out = []
    for i in (0, 2, 4):
        c = int(s[i:i+2], 16) / 255
        lin = c ** 2.2
        v = 12.92 * lin if lin <= 0.0031308 else 1.055 * lin ** (1/2.4) - 0.055
        out.append(max(0, min(255, round(v * 255))))
    return "".join(f"{v:02X}" for v in out)

BORDER_WIDTH = 8
MODE_COLORS = {
    usertypes.KeyMode.insert:      precompensate(c.colors.statusbar.insert.bg),
    usertypes.KeyMode.command:     precompensate(c.colors.statusbar.command.bg),
    usertypes.KeyMode.hint:        precompensate(c.colors.hints.bg),
    usertypes.KeyMode.passthrough: precompensate(c.colors.statusbar.passthrough.bg),
    usertypes.KeyMode.caret:       precompensate(c.colors.statusbar.caret.bg),
}

def _set_props(*pairs):
    cmds = " ; ".join(
        f"dispatch hl.dsp.window.set_prop({{prop=[[{p}]],value={v}}})"
        for p, v in pairs
    )
    QProcess.startDetached("hyprctl", ["--batch", cmds])

def _apply(mode):
    color = MODE_COLORS.get(mode)
    if color is None:
        _set_props(("border_size", "0"))
        return
    _set_props(
        ("active_border_color", f"[[rgb({color})]]"),
        ("inactive_border_color", f"[[rgb({color})]]"),
        ("border_size", BORDER_WIDTH),
    )


HIDDEN_MODES = {usertypes.KeyMode.hint, usertypes.KeyMode.insert, usertypes.KeyMode.passthrough}

if not getattr(bar.StatusBar.maybe_hide, "_hide_insert_patched", False):
    _orig_maybe_hide = bar.StatusBar.maybe_hide

    def _patched_maybe_hide(self):
        _orig_maybe_hide(self)
        if qbconfig.val.statusbar.show != 'in-mode':
            return
        try:
            mm = modeman.instance(self._win_id)
        except modeman.UnavailableError:
            return
        if mm.mode in HIDDEN_MODES:
            self.hide()

    _patched_maybe_hide._hide_insert_patched = True
    bar.StatusBar.maybe_hide = _patched_maybe_hide


def _refresh_bar(win_id):
    def _do():
        try:
            mw = objreg.get('main-window', scope='window', window=win_id)
        except KeyError:
            return
        mw.status.maybe_hide()
    QTimer.singleShot(0, _do)


if not getattr(modeman.ModeManager.__init__, "_hypr_patched", False):
    _orig_init = modeman.ModeManager.__init__

    def _patched_init(self, win_id, parent=None):
        _orig_init(self, win_id, parent)
        self.entered.connect(
            lambda mode, *_: (_apply(mode), _refresh_bar(win_id)))
        self.left.connect(
            lambda *_: (_apply(usertypes.KeyMode.normal), _refresh_bar(win_id)))

    _patched_init._hypr_patched = True
    modeman.ModeManager.__init__ = _patched_init
