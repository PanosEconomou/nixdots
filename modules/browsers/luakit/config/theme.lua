--------------------------------
-- Dracula theme for luakit    --
-- Matches Dracula qutebrowser --
-- color scheme                --
--------------------------------

local theme = {}

-- Default settings
theme.font                 = "12px monospace"
theme.veryhigh_font        = "20px Cursive"
theme.selected_font        = theme.font
theme.form_ok_font         = theme.font
theme.form_softfail_font   = theme.font
theme.form_hardfail_font   = theme.font

-- Base Dracula palette
local bg        = "#282a36"
local bg_light  = "#44475a"
local fg        = "#f8f8f2"
local comment   = "#6272a4"
local cyan      = "#8be9fd"
local green     = "#50fa7b"
local orange    = "#ffb86c"
local pink      = "#ff79c6"
local purple    = "#bd93f9"
local red       = "#ff5555"
local yellow    = "#f1fa8c"

-- General settings
theme.fg                        = fg
theme.bg                        = bg

-- Genereal notification / warning colors
theme.notif_fg_color            = fg
theme.notif_bg_color            = bg

theme.error_fg_color            = red
theme.error_bg_color            = bg

-- Warning colors
theme.warning_fg_color          = yellow
theme.warning_bg_color          = bg

-- Statusbar specific
theme.sbar_fg                   = fg
theme.sbar_bg                   = bg

-- Downloadbar
theme.dbar_fg                   = fg
theme.dbar_bg                   = bg
theme.dbar_error_fg              = red

-- Menu
theme.menu_fg                   = fg
theme.menu_bg                   = bg
theme.menu_selected_fg          = fg
theme.menu_selected_bg          = bg_light

theme.menu_disabled_fg          = comment
theme.menu_disabled_bg          = bg

theme.menu_title_bg             = bg_light
theme.menu_primary_title_fg     = purple
theme.menu_secondary_title_fg   = comment

-- Proxy manager
theme.proxy_active_menu_fg      = green
theme.proxy_active_menu_bg      = bg
theme.proxy_inactive_menu_fg    = comment
theme.proxy_inactive_menu_bg    = bg

-- Statusbar text and background colors
theme.uri_sfg                   = comment
theme.uri_efg                   = comment

theme.uri_sbg                   = bg
theme.uri_ebg                   = bg

theme.loaded_sfg                = cyan
theme.loaded_efg                = green

theme.buf_sfg                   = pink
theme.buf_ebg                   = bg
theme.buf_efg                   = pink
theme.buf_sbg                   = bg

theme.tabtitle_sfg              = fg
theme.tabtitle_efg              = fg

theme.tabtitle_sbg              = bg
theme.tabtitle_ebg              = bg

theme.ssl_trusted_fg            = green
theme.ssl_untrusted_fg          = red

theme.tab_ssl_trusted_fg        = green
theme.tab_ssl_untrusted_fg      = red

theme.hint_font                 = "bold 10px monospace"
theme.hint_fg                   = bg
theme.hint_bg                   = purple
theme.hint_bg_opacity           = 0.85
theme.hint_border               = "1px solid " .. purple
theme.hint_overlay_bg           = purple
theme.hint_overlay_border       = "1px solid " .. purple
theme.hint_overlay_opacity      = 0.3
theme.hint_overlay_text_bg      = bg
theme.hint_overlay_text_fg      = fg

-- Tab title colors
theme.tab_fg                    = fg
theme.tab_bg                    = bg_light

theme.tab_ntheme                = fg
theme.tab_selected_fg           = fg
theme.tab_selected_bg           = bg

theme.tab_hover_bg               = bg_light

theme.tab_loading_fg            = cyan

-- Trusted/untrusted SSL colors
theme.trust_fg                  = green
theme.notrust_fg                = red

-- Downloadbar colors
theme.dbar_error_fg             = red

-- Input field colors (bar for :command mode, search, etc.)
theme.input_fg                  = fg
theme.input_bg                  = bg

-- Completion widget
theme.completion_fg              = fg
theme.completion_bg              = bg
theme.completion_border          = bg_light
theme.completion_title_fg        = purple
theme.completion_title_bg        = bg_light
theme.completion_odd_bg          = bg
theme.completion_even_bg         = bg
theme.completion_focus_fg        = fg
theme.completion_focus_bg        = bg_light

return theme
-- vim: et:sw=4:ts=8:sts=4:tw=80
