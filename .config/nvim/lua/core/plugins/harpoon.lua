local M = {
    "theprimeagen/harpoon",
    config = function()
        require("harpoon").setup({
            menu = {
                -- configure a custom width by setting the menu's width relative to the current window's width.
                width = vim.api.nvim_win_get_width(0) - 32,
            },
        })

        vim.cmd([[
		  augroup HarpoonConfig
			autocmd!
			autocmd FileType harpoon setlocal wrap
		  augroup end
		]])
        local mark = require("harpoon.mark")
        local ui = require("harpoon.ui")

        vim.keymap.set("n", "<leader>ah", mark.add_file, { desc = "[ah] [A]dd file to [H]arpoon" })
        vim.keymap.set("n", "<C-e>", ui.toggle_quick_menu, { desc = "Toggle Harpoon Menu" })

        vim.keymap.set("n", "<C-h>", function()
            ui.nav_file(1)
        end, { desc = "Harpoon me 1" })
        vim.keymap.set("n", "<C-t>", function()
            ui.nav_file(2)
        end, { desc = "Harpoon me 2" })
        vim.keymap.set("n", "<C-n>", function()
            ui.nav_file(3)
        end, { desc = "Harpoon me 3" })
        vim.keymap.set("n", "<C-s>", function()
            ui.nav_file(4)
        end, { desc = "Harpoon me 4" })
    end,
}
return M
