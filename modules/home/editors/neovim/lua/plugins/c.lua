-- Formatting for the c language and cmake stuff
return {
    {
        "mfussenegger/nvim-lint",
        config = function()
            require("lint").linters_by_ft = {
                cmake = { "cmake_lint" }
            }
            vim.api.nvim_create_autocmd({ 'BufWritePost', 'BufReadPost' }, {
                callback = function() require('lint').try_lint() end
            })
        end,
    },
    {
        "Civitasv/cmake-tools.nvim",
        dependencies = { "nvim-lua/plenary.nvim" },
        ft = { "cmake", "c", "cpp" },
        opts = {
            cmake_build_directory = "build/${variant:buildType}",
            cmake_soft_link_compile_commands = true,
        },
        keys = {
            { "<leader>cg", "<cmd>CMakeGenerate<cr>", desc = "CMake generate" },
            { "<leader>cb", "<cmd>CMakeBuild<cr>",    desc = "CMake build" },
            { "<leader>cr", "<cmd>CMakeRun<cr>",      desc = "CMake run" },
        },
    },
}
