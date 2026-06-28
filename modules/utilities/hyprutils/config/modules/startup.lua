-- Constrols startup processes
local exec = hl.exec_cmd

hl.on("hyprland.start", function()
    exec("echo done >> ~/test")
    exec("hypridle")
    exec("hyprpaper")
    exec("hyprsunset")
end)
