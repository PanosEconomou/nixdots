-- Constrols startup processes
local exec = hl.exec_cmd

hl.on("hyprland.start", function()
    exec("hypridle")
    exec("hyprpaper")
    exec("hyprsunset")
    exec("qs -c bar")
    exec("qs -c drawer")
end)
