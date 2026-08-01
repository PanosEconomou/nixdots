-- Some Plugins for setting up the overall UI ---------------------------------------------
return {
    -- Icons
    {
        "echasnovski/mini.icons",
        lazy = true,
        opts = {
            style = "glyph",
        },
    },

    -- File Explorer
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "echasnovski/mini.icons" },
        cmd          = "NvimTreeToggle",
        opts         = {
            filters = {
                custom = {
                    "\\.git$", "\\.jpg$", "\\.mp4$", "\\.ogg$", "\\.iso$",
                    "\\.pdf$", "\\.pyc$", "\\.odt$", "\\.png$", "\\.gif$", "\\.db$",
                },
            },
            renderer = {
                group_empty = true,
            },
            view = {
                width = 30,
            },
        },
    },


    -- Statusline
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "echasnovski/mini.icons" },
        opts         = {
            options     = {
                theme                = require("config.theme").build();
                globalstatus         = true,
                component_separators = '',
                section_separators   = { left = '', right = '' },
            },
            sections = {
                lualine_a = { { "mode", separator = { left = '', right = '' }, right_padding = 2 } },
                lualine_b = { "branch", "diff", "diagnostics" },
                lualine_c = { { "filename", path = 1 } },
                lualine_x = { "filetype" },
                lualine_y = { "searchcount" },
                lualine_z = { {"location", separator = { left = '', right = '' }, left_padding = 2} },
            },
            tabline = {};
            extensions = {};
        },
    },

    -- Make the command promt pretty!
    { "MunifTanjim/nui.nvim", lazy = true },
    {
        "folke/noice.nvim",
        event        = "VeryLazy",
        dependencies = {
            "MunifTanjim/nui.nvim",
        },
        opts = {
            cmdline = {
                view = "cmdline_popup",
                format = {
                    cmdline   = { icon = ":" },
                    search_down = { icon = "/ " },
                    search_up   = { icon = "? " },
                },
            },
            views = {
                cmdline_popup = {
                    position = {
                        row  = -2,    -- 2 lines from bottom, sits just above statusline
                        col  = "50%", -- centered horizontally
                    },
                    size = {
                        width  = 70,
                        height = "auto",
                    },
                    border = {
                        style   = "rounded",
                        padding = { 0, 1 },
                    },
                },
            },
            messages  = { enabled = true },
            popupmenu = { enabled = true },
            lsp = {
                -- let fidget handle lsp progress
                progress = { enabled = false },
            },
            routes = {
                {
                    filter = { event = 'msg_show', kind = { 'shell_out', 'shell_err' } },
                    view = 'popup',
                    opts = {
                        level = 'info',
                        skip = false,
                        replace = false,
                    },
                },
                {
                    filter = { event = "msg_show", kind = "search_count" },
                    opts   = { skip = true },
                },
            },
        },
    },
}
