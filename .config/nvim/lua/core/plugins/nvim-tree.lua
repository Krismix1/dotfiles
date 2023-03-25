-- fast tree view for file navigation
local M = {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            git = { enable = true, ignore = true },
            -- view = {
            -- auto_resize = true
            -- mappings = {list = {{key = "<Tab>", action = "preview"}}}
            -- }
            sort_by = "case_sensitive",
            view = {
                width = 30,
                mappings = {
                    list = {
                        { key = "u", action = "dir_up" },
                    },
                },
            },
            renderer = {
                group_empty = true,
            },
            --  filters = {
            --      dotfiles = true,
            --  },
        })

        local nvim_tree = require("nvim-tree.api").tree
        vim.keymap.set("n", "<C-_>", function()
            nvim_tree.toggle({ find_file = true, update_root = false, current_window = false })
        end)
    end,
}

return M
