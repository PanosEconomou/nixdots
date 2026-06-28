-- Handle what happens to the display when the lid is closed
-- Load the monitor config
local display  = require("modules.monitors")
local internal = display.output
local kbd      = "dell::kbd_backlight"

-- Check for external monitors 
local function has_external_monitors()
    local monitors = hl.get_monitors()
    for _, m in ipairs(monitors) do
        if m.name ~= internal then
            return true
        end
    end
    return false
end

-- Turns Keyboard light off 
local function disable_keyboard()
    hl.exec_cmd("brightnessctl -d " .. kbd .. " s 0%")
end

-- Turns Keyboard light on
local function enable_keyboard()
    hl.exec_cmd("brightnessctl -d " .. kbd .. " s 60%")
end

-- Turns off internal monitor 
local function disable_internal()
    hl.monitor({ output = internal, disabled = true })
end

-- Turns on internal monitor 
local function enable_internal()
    hl.monitor(display)
end

-- Lid closed
hl.bind("switch:on:Lid Switch", function()
    disable_keyboard()
    if has_external_monitors() then
        disable_internal()
    else
        hl.exec_cmd("loginctl lock-session")
    end
end)

-- Lid opened
hl.bind("switch:off:Lid Switch", function()
    enable_keyboard()
    enable_internal()
end)
