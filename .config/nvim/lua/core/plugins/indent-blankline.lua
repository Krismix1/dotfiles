-- better visualization of spaces/newlines
local M = {
    "lukas-reineke/indent-blankline.nvim",
    config = function()
        vim.opt.list = true
        vim.opt.listchars:append("eol:↴")
        vim.opt.listchars:append("tab:>·")
        vim.opt.listchars:append("trail:~")
        vim.opt.listchars:append("extends:>")
        vim.opt.listchars:append("precedes:<")
        vim.opt.listchars:append("space:·")
        require("indent_blankline").setup({
            -- for example, context is off by default, use this to turn it on
            show_current_context = true,
            show_current_context_start = true,
            show_end_of_line = true,
            space_char_blankline = " ",
            show_trailing_blankline_indent = false,
            char = "┊",
        })
    end,
}

return M
