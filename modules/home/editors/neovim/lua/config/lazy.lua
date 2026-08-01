-- Lazy vim setup -------------------------------------------------------------
-- This is the plugin manager

-- Bootstrap Lazyvim
local lazypath = vim.fn.stdpath("data").."/lazy/lazy.nvim"
if not vim.uv.fs_stat(lazypath) then
    vim.fn.system({
        "git", "clone", "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

-- Load Plugins
-- The "plugins" searches in lua/plugins for all the files automatically 
require("lazy").setup("plugins", {
    ui      = { border = "rounded" },
    checker = {
        enabled = true,     -- Check for plugins updates
        notify  = false,    -- But don't tell me all the time
    },
})

-- -- Load the matugen colors
-- vim.opt.runtimepath:prepend(
--   (vim.env.XDG_CACHE_HOME or vim.env.HOME .. "/.cache") .. "/matugen"
-- )
--
-- -- Reload lualine when matugen regenerates colors
-- local dir = vim.fn.expand("~/.cache/matugen/lua/matugen")
-- local w = vim.uv.new_fs_event()
-- if w then
--   local ok = w:start(dir, {}, vim.schedule_wrap(function()
--     require("config.theme_reload")()
--   end))
--   if not ok then w:close() end
-- end
