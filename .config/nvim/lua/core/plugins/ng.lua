local M = {
    "joeveiga/ng.nvim",
    config = function()
        local ng_opts = { noremap = true, silent = true }
        local ng = require("ng")
        vim.keymap.set("n", "<leader>at", ng.goto_template_for_component, ng_opts)
        vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file, ng_opts)
        vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, ng_opts)
    end,
}
return M
