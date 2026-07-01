-- A set of default programs for keybinds etc.
-- Not to be confused with default mimeapps these could be different

local default = {}

default.mod             = "SUPER"
default.terminal        = "kitty"
default.fileManager     = "kitty -e bash -c 'source ~/.config/nnn/nnn.sh && exec nnn'"
-- default.menu            = "pkill -USR1 wofi || wofi --show drun"
default.menu            = "qs -c drawer ipc show >/dev/null 2>&1 && qs -c drawer kill || qs -c drawer & disown"
default.browser         = "qutebrowser"
default.altBrowser      = "firefox"
default.lock            = "hyprlock"
default.chat            = default.browser.." https://web.whatsapp.com/"
default.todo            = default.browser.." https://github.com/users/PanosEconomou/projects/3"
-- default.bar             = "pkill waybar || waybar"
default.bar             = "qs -c bar ipc show >/dev/null 2>&1 && qs -c bar kill || qs -c bar & disown"
default.printscreen     = 'grim -g "$(slurp -w 0)"'
default.latexclip       = "~/.config/hypr/scripts/latexclip.sh"
default.sunset          = require("scripts.sunset")
default.cursorTheme     = "GoogleDot-White"
default.cursorSize      = "20"

return default
