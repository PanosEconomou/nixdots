-- Basic Settings Configuration
local settings  = require "settings"
local downloads = require "downloads"

-- Homepage
settings.window.home_page                   = "https://home.panos.wiki"
settings.window.new_tab_page                = "https://home.panos.wiki"

-- Search Engines
settings.window.search_engines.d            = "https://duckduckgo.com/%s"
settings.window.search_engines.aw           = "https://wiki.archlinux.org/?search=%s"
settings.window.search_engines.g            = "https://github.com/search?q=%s"
settings.window.search_engines.nix          = "https://search.nixos.org/packages?query=%s"
settings.window.search_engines.default      = "https://duckduckgo.com/%s"

-- Scrolling
settings.webview.enable_smooth_scrolling    = true

-- Downloads
downloads.default_dir                       = os.getenv("HOME").."/downloads"

-- Per domain settings
settings.on["youtube.com"].webview.enable_webgl = true
settings.on["figma.com"].webview.hardware_acceleration_policy = "always"
