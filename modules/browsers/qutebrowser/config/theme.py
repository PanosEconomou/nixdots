from pathlib import Path
from json import loads
import themes.dracula.draw
import themes.live.draw

COLORS_FILE = Path.home() / Path(".local/state/qutebrowser/colors.json")

if COLORS_FILE.is_file():
    colors = loads(COLORS_FILE.read_text())
    themes.live.draw.blood(c, colors, {
        'spacing': {'vertical': 6, 'horizontal': 8}
    })
else:
    themes.dracula.draw.blood(c, {
        'spacing': {'vertical': 6, 'horizontal': 8}
        })
