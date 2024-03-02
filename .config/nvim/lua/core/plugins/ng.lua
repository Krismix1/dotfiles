local M = {
    "joeveiga/ng.nvim",
    ft = "angular.html",
    config = function()
        local ng = require("ng")
        vim.fn.bufnr()
        vim.keymap.set(
            "n",
            "<leader>at",
            ng.goto_template_for_component,
            { noremap = true, silent = true, buffer = true, desc = "[A]ngular: go to [t]emplate" }
        )
        vim.keymap.set(
            "n",
            "<leader>ac",
            ng.goto_component_with_template_file,
            { noremap = true, silent = true, buffer = true, desc = "[A]ngular: go to [c]omponent" }
        )
        vim.keymap.set(
            "n",
            "<leader>aT",
            ng.get_template_tcb,
            { noremap = true, silent = true, buffer = true, desc = "[A]ngular: Display template [t]ypecheck block" }
        )
    end,
}
return M
