-- Some plugins that make the editing experience better for everything
return {
    -- Auto Pair parentheses
    {
        "echasnovski/mini.pairs",
        event = "InsertEnter",   -- only load when you enter insert mode
        opts  = {},
    },

    -- Add comments automatically
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        opts  = {},   -- gcc to comment line, gc{motion} for range
    },

    -- Customize start screen
    {
        "goolord/alpha-nvim",
        event = "VimEnter",
        config = function()
            local alpha = require("alpha")
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[  ╻   ╻  ┏━┓┏━┓╺┳╸  ]],
                [[  ┃   ┃  ┃ ┃┗━┓ ┃   ]],
                [[  ╹   ┗━╸┗━┛┗━┛ ╹   ]],
                [[       ┏┳┓╻ ╻       ]],
                [[       ┃┃┃┗┳┛       ]],
                [[       ╹ ╹ ╹        ]],
                [[ ┏━╸╻ ╻┏━┓┏━┓┏━┓┏━┓ ]],
                [[ ┃  ┃ ┃┣┳┛┗━┓┃ ┃┣┳┛ ]],
                [[ ┗━╸┗━┛╹┗╸┗━┛┗━┛╹┗╸ ]],
            }
            local function get_top_padding()
                local art_height = #dashboard.section.header.val
                return math.max(0, math.floor((vim.fn.winheight(0) - art_height) / 2))
            end
            -- Layout with ONLY the header (no buttons, no footer)
            dashboard.config.layout = {
                { type = "padding", val = get_top_padding()},
                dashboard.section.header,
            }

            -- Don't let the header be selectable/highlighted as a button
            dashboard.section.header.opts.hl = "AlphaHeader"

            alpha.setup(dashboard.config)
        end,
    }

}
