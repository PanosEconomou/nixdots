-- Formatting for the c language and cmake stuff
return {
    -- {
    --     "mfussenegger/nvim-lint",
    --     config = function()
    --         require("lint").linters_by_ft = {
    --             cmake = { "cmake_lint" }
    --         }
    --         vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
    --             callback = function() require('lint').try_lint() end
    --         })
    --     end,
    -- },
}
