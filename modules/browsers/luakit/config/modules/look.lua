-- Adding a custom border and removing some mode indicators
-- This needs hyprland to work properly

local window = require "window"
local luakit = package.loaded["luakit"]
local modes  = package.loaded["modes"]

local config = {
    font = "10px monospace",

    border_width = 8,

    default = { bg = "#585b70", fg = "#cdd6f4", text = "--" },

    modes = {
        insert      = { bg = "#000000", fg = "#11111b", text = "-- INSERT --" },
        command     = { bg = "#000000", fg = "#11111b", text = "-- COMMAND --" },
        search      = { bg = "#000000", fg = "#11111b", text = "-- SEARCH --" },
        follow      = { bg = "#000000", fg = "#11111b", text = "-- FOLLOW --" },
        passthrough = { bg = "#000000", fg = "#11111b", text = "-- PASSTHROUGH --" },
        lua         = { bg = "#000000", fg = "#11111b", text = "-- LUA --" },
    },
}

local function style_for (mode)
    if mode == "normal" then return nil end
    return config.modes[mode] or config.default
end


local BORDER_CMD =
    "hyprctl dispatch hl.dsp.window.set_prop({prop=[[active_border_color]],value=[[rgb(%s)]]})"

local BORDER_INACTIVE_CMD =
    "hyprctl dispatch hl.dsp.window.set_prop({prop=[[inactive_border_color]],value=[[rgb(%s)]]})"

local SIZE_CMD =
    "hyprctl dispatch hl.dsp.window.set_prop({prop=[[border_size]],value=%d})"

local function set_border (colour, size)
    if size > 0 then luakit.spawn(BORDER_CMD:format(colour:sub(2))) end
    if size > 0 then luakit.spawn(BORDER_INACTIVE_CMD:format(colour:sub(2))) end
    luakit.spawn(SIZE_CMD:format(size))
end

window.add_signal("build", function (w)
    w.sbar.ebox.visible = false
    w:add_signal("mode-changed", function(_, mode)
        local style = style_for(mode)
        local shown = (style ~= nil)
        w.ibar.ebox.visible = shown and mode ~= "insert"
        set_border(style and style.bg, shown and config.border_width or 0)
    end)
end)

modes.get_modes()["insert"].enter = function(w)
    -- w:set_prompt("-- INSERT --") -- Commented out to hide the status line
    w:set_prompt()
    w:set_input()
    w.view.can_focus = true
    w.view:focus()
end
-- window.add_signal("init", function (w)
--     local style = style_for(lousy.mode.get(w))
--     local shown = style ~= nil
--     set_border(style and style.bg, shown and config.border_width or 0)
-- end)
