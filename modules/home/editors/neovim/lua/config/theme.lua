local M = {}

local COLORS = vim.fn.expand("~/.cache/matugen/lua/live/colors.lua")

-- Load the matugen colors to build the theme
function M.build()
    local ok, c = pcall(dofile, COLORS)
    if not ok then return require("lualine.themes.tokyonight") end

    local function bubble(bg, fg) return { a = { bg = bg, fg = fg, gui = "bold" } } end

    return {
        normal = {
            a = { bg = c.primary, fg = c.on_primary, gui = "bold" },
            b = { bg = c.surface_container_high, fg = c.on_surface },
            c = { bg = "NONE", fg = c.on_surface_variant },
        },
        insert   = bubble(c.tertiary,  c.on_tertiary),
        visual   = bubble(c.secondary, c.on_secondary),
        replace  = bubble(c.error,     c.on_error),
        command  = bubble(c.primary_container, c.on_primary_container),
        inactive = {
            a = { bg = "NONE", fg = c.outline },
            b = { bg = "NONE", fg = c.outline },
            c = { bg = "NONE", fg = c.outline },
        },
    }
end

-- Set the highlight colors based on matugen primary
function M.highlights()
    local ok, c = pcall(dofile, COLORS)
    if not ok then return end

    local hl = vim.api.nvim_set_hl
    hl(0, "NoiceCmdlinePopupBorder",    { fg = c.primary })
    hl(0, "NoiceCmdlinePopupTitle",     { fg = c.primary, bold = true })
    hl(0, "NoiceCmdlineIcon",           { fg = c.primary })
    hl(0, "NoiceCmdlinePopup",          { bg = "NONE" })
    hl(0, "NoicePopupBorder",           { fg = c.primary })
    hl(0, "NoiceConfirmBorder",         { fg = c.primary })
    hl(0, "DiffAdd",                    { fg = c.tertiary })
    hl(0, "DiffChange",                 { fg = c.secondary })
    hl(0, "DiffDelete",                 { fg = c.error })
end

-- Small script to live reload the theme from matugen
function M.reload()
    local lualine = require("lualine")
    local cfg = lualine.get_config()
    cfg.options.theme = M.build()
    lualine.setup(cfg)
    M.highlights()
end

-- Watch the theme for changes to achieve live reload
function M.watch()
    local w = vim.uv.new_fs_event()
    if not w then return end
    local ok = w:start(vim.fs.dirname(COLORS), {}, vim.schedule_wrap(M.reload))
    if not ok then w:close() end
end

-- Something to run once on load
function M.start()
    M.watch()
    M.highlights()
end

return M
