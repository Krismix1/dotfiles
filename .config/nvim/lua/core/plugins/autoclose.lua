local M = {
    "m4xshen/autoclose.nvim",
    config = function()
        require("autoclose").setup({
            options = {
                disabled_filetypes = {},
                disable_when_touch = true,
            },
            keys = {
                ["<"] = { escape = true, close = true, pair = "<>" },
                ["|"] = { escape = true, close = true, pair = "||" },
            },
        })
        vim.g.vimtex_compiler_progname = "nvr"
    end,
}
return M
