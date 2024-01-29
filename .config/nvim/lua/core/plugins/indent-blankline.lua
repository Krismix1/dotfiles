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
        require("ibl").setup({
            indent = { char = "┊" },
        })
    end,
}

return M
