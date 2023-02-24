-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ 'n', 'v' }, '<Space>', '<Nop>', { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set('n', 'k', "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set('n', 'j', "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })


-- See `:help telescope.builtin`
local telescope_builtins = require('telescope.builtin')
vim.keymap.set('n', '<leader>?', telescope_builtins.oldfiles, { desc = '[?] Find recently opened files' })
vim.keymap.set('n', '<leader><space>', telescope_builtins.buffers, { desc = '[ ] Find existing buffers' })
vim.keymap.set('n', '<leader>cm', telescope_builtins.keymaps, { desc = '[C]ommand [M]enu' })
vim.keymap.set('n', '<leader>/', function()
    -- You can pass additional configuration to telescope to change theme, layout, etc.
    telescope_builtins.current_buffer_fuzzy_find(require('telescope.themes').get_dropdown {
        winblend = 10,
        previewer = false,
    })
end, { desc = '[/] Fuzzily search in current buffer]' })

vim.keymap.set('n', '<C-p>', function() telescope_builtins.find_files({ hidden = true }) end,
    { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sh', telescope_builtins.help_tags, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sw', telescope_builtins.grep_string, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sg', telescope_builtins.live_grep, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sd', telescope_builtins.diagnostics, { desc = '[S]earch [D]iagnostics' })

-- Diagnostic keymaps
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<leader>e', vim.diagnostic.open_float)
vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist)


-- from primeagen
-- https://www.youtube.com/watch?v=w7i4amO_zaE
-- local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
-- vim.keymap.set("n", "<C-p>", builtin.git_files, {})
-- vim.keymap.set("n", "<leader>ps", function()
--     builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end)
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- allow moving seleced lines up and down
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keep cursor at current position when smart concating lines
vim.keymap.set("n", "J", "mzJ`z")

-- keep current at the middle of the screen when jumping pages
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- keep search term in the middle
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- paste over without copying into register 0, but the null register
vim.keymap.set("x", "<leader>p", [["_dP]])

-- some remaps to use separate registers for system clipboard
-- TODO:
-- vim.keymap.set({"n", "v"}, "<leader>y", [["+y]])
-- vim.keymap.set("n", "<leader>Y", [["+Y]])
-- vim.keymap.set({"n", "v"}, "<leader>d", [["_d]])

vim.keymap.set("n", "Q", "<nop>")

-- revert with CTRL+a L
vim.keymap.set("n", "<C-f>", "<cmd>silent !tmux neww tmux-sessionizer<CR>")
vim.keymap.set("n", "<leader>f", vim.lsp.buf.format)


-- ??? some navigation tricks
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace current word trick
vim.keymap.set("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
-- chmod current file
-- vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>");

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et

-- disable netrw at the very start of your init.lua (strongly advised)
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- set termguicolors to enable highlight groups
vim.opt.termguicolors = true

local nvim_tree = require("nvim-tree.api").tree
vim.keymap.set("n", "<C-_>", function()
    nvim_tree.toggle({ find_file = true, update_root = false, current_window = false })
end
);
local ng_opts = { noremap = true, silent = true }
local ng = require("ng");
vim.keymap.set("n", "<leader>at", ng.goto_template_for_component, ng_opts)
vim.keymap.set("n", "<leader>ac", ng.goto_component_with_template_file, ng_opts)
vim.keymap.set("n", "<leader>aT", ng.get_template_tcb, ng_opts)
