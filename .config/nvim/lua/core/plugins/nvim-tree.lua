-- fast tree view for file navigation

-- This function has been generated from your
--   view.mappings.list
--   view.mappings.custom_only
--   remove_keymaps
--
-- You should add this function to your configuration and set on_attach = on_attach in the nvim-tree setup call.
--
-- Although care was taken to ensure correctness and completeness, your review is required.
--
-- Please check for the following issues in auto generated content:
--   "Mappings removed" is as you expect
--   "Mappings migrated" are correct
--
-- Please see https://github.com/nvim-tree/nvim-tree.lua/wiki/Migrating-To-on_attach for assistance in migrating.
--

local function on_attach(bufnr)
    local api = require("nvim-tree.api")
    api.config.mappings.default_on_attach(bufnr)

end

local M = {
    "kyazdani42/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
        require("nvim-tree").setup({
            git = { enable = true, ignore = true },
            sort_by = "case_sensitive",
            view = {
                width = 40,
            },
            renderer = {
                group_empty = true,
            },
            --  filters = {
            --      dotfiles = true,
            --  },
            on_attach = on_attach,
        })

        local nvim_tree = require("nvim-tree.api").tree
        local function toggle_tree()
            nvim_tree.toggle({ find_file = true, update_root = false, current_window = false })
        end
        -- this runs when inside tmux...
        vim.keymap.set("n", "<C-_>", toggle_tree)
        -- this runs when outside tmux...
        vim.keymap.set("n", "<C-/>", toggle_tree)
    end,
}

return M
