-- This is a very commonly used plugin that takes code and builds a syntax tree for easy parsing
return {
    {
        "nvim-treesitter/nvim-treesitter",
        build   = ":TSUpdate",                        -- update parsers when plugin updates
        branch  = "main",
        config  = function()
            -- Prarses 
            local parsers = {
                -- Programming Languages
                "c", "cpp", "python", "julia", "javascript", "typescript",

                -- Scripting
                "bash", "lua", "qmljs",

                -- Data
                "json", "yaml", "toml",

                -- Web
                "html", "css",

                -- Docs
                "markdown", "markdown_inline",

                -- Nvim
                "vim", "vimdoc",
            }
            require("nvim-treesitter").install(parsers)

            vim.api.nvim_create_autocmd("FileType", {
                callback = function(ev)
                    -- Highlighting: no-ops quietly if no parser exists for this filetype
                    local ok = pcall(vim.treesitter.start)
                    if not ok then return end

                    -- latex needs both treesitter AND vim regex highlighting,
                    -- since vimtex relies on vim regex highlighting.
                    if ev.match == "tex" or ev.match == "plaintex" then
                        vim.bo[ev.buf].syntax = "ON"
                    end

                    -- Treesitter-based folding
                    vim.wo[0][0].foldmethod = "expr"
                    vim.wo[0][0].foldexpr   = "v:lua.vim.treesitter.foldexpr()"

                    -- Treesitter-based indentation (experimental, matches old indent.enable)
                    vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
                end,
            })
        end
    },
    {
        "MeanderingProgrammer/treesitter-modules.nvim",
        dependencies = { "nvim-treesitter/nvim-treesitter" },
        ---@module 'treesitter-modules'
        ---@type ts.mod.UserConfig
        opts = {
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection    = "<CR>",   -- start selection
                    node_incremental  = "<CR>",   -- expand to next node
                    node_decremental  = "<BS>",   -- shrink selection
                    scope_incremental = "<TAB>",  -- expand to scope
                },
            },
        },
    },
}
