-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- See `:help telescope.builtin`
local telescope_builtins = require("telescope.builtin")
vim.keymap.set("n", "<leader>?", telescope_builtins.oldfiles, { desc = "[?] Find recently opened files" })
vim.keymap.set("n", "<leader><space>", telescope_builtins.buffers, { desc = "[ ] Find existing buffers" })
vim.keymap.set("n", "<leader>cm", telescope_builtins.keymaps, { desc = "[C]ommand [M]enu" })
vim.keymap.set("n", "<leader>/", telescope_builtins.current_buffer_fuzzy_find , { desc = "[/] Fuzzily search in current buffer" })
vim.keymap.set("n", "<C-p>", function()
    telescope_builtins.find_files({ hidden = true })
end, { desc = "[S]earch [F]iles" })


local live_grep_with_glob = function (opts)
    local pickers = require"telescope.pickers"
    local finders = require"telescope.finders"
    local make_entry = require"telescope.make_entry"
    local conf = require"telescope.config".values
    opts = opts or {}
    opts.cwd = opts.cwd or vim.uv.cwd()

    local finder = finders.new_async_job {
        command_generator = function (prompt)
            if not prompt or prompt == "" then
                return nil
            end

            local pieces = vim.split(prompt, "  ")
            local args = { "rg" }
            if pieces[1] then
                table.insert(args, "-e")
                table.insert(args, pieces[1])
            end

            if pieces[2] then
                table.insert(args, "-g")
                table.insert(args, pieces[2])
            end

            return  vim.iter({
                args,
                {"--color=never", "--no-heading", "--with-filename", "--line-number", "--column", "--smart-case", "--hidden"}
            }):flatten():totable()
        end,
        entry_maker = make_entry.gen_from_vimgrep(opts),
        cwd = opts.cwd,
    }

    pickers.new(opts, {
        debounce = 100,
        prompt_title = "Live Grep (+glob)",
        finder = finder,
        previewer = conf.grep_previewer(opts),
        sorter = require("telescope.sorters").empty(),
    }):find()
end

vim.keymap.set("n", "<leader>sh", telescope_builtins.help_tags, { desc = "[S]earch [H]elp" })
vim.keymap.set("n", "<leader>sw", telescope_builtins.grep_string, { desc = "[S]earch current [W]ord" })
-- vim.keymap.set("n", "<leader>sg", telescope_builtins.live_grep, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sg", live_grep_with_glob, { desc = "[S]earch by [G]rep" })
vim.keymap.set("n", "<leader>sd", telescope_builtins.diagnostics, { desc = "[S]earch [D]iagnostics" })

-- Diagnostic keymaps
vim.keymap.set("n", "[d", function () vim.diagnostic.jump({count=-1, float=true}) end, { desc = "Go to previous diagnostic issue" })
vim.keymap.set("n", "]d", function () vim.diagnostic.jump({count=1, float=true}) end, { desc = "Go to next diagnostic issue" })
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Show [e]rrors in floating window" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Add buffer diagnostics to location list" })

-- from primeagen
-- https://www.youtube.com/watch?v=w7i4amO_zaE
-- local builtin = require("telescope.builtin")
-- vim.keymap.set("n", "<leader>pf", builtin.find_files, {})
-- vim.keymap.set("n", "<C-p>", builtin.git_files, {})
-- vim.keymap.set("n", "<leader>ps", function()
--     builtin.grep_string({ search = vim.fn.input("Grep > ") })
-- end)
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)

-- allow moving selected lines up and down
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

-- ??? some navigation tricks
-- vim.keymap.set("n", "<C-k>", "<cmd>cnext<CR>zz")
-- vim.keymap.set("n", "<C-j>", "<cmd>cprev<CR>zz")
-- vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
-- vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- chmod current file
vim.keymap.set("n", "<leader>x", "<cmd>!chmod +x %<CR>", { silent = true })

local map = vim.keymap.set
local default_options = { silent = true, noremap = true }
-- local expr_options = {expr = true, silent = true}

-- -- Paste over currently selected text without yanking it
-- map("v", "p", '"_dp', default_options)
-- map("v", "P", '"_dP', default_options)

-- Re-source VIMRC
map("n", "<leader>sv", ":luafile $MYVIMRC<CR>", default_options)

-- -- Remove search highlight
-- map('n', '<leader>/', ':nohlsearch<CR>', default_options)

-- -- Dealing with word wrap
-- map('n', 'k', "v:count == 0 ? 'gk' : 'k'", expr_options)
-- map('n', 'j', "v:count == 0 ? 'gj' : 'j'", expr_options)

-- Use :w!! to write with sudo even if not opened with
map("c", "w!!", "w !sudo tee >/dev/null %", default_options)

-- Clever replacement bindings courtesy of romainl
map("n", "<leader>rr", [[ :'{,'}s/\<<C-r>=expand("<cword>")<CR>\>/ ]], default_options)
map("n", "<leader>r%", [[ :%s/\<<C-r>=expand("<cword>")<CR>\>/ ]], default_options)
-- replace current word trick, courtesy of ThePrimeagen
map("n", "<leader>rw", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], { desc = "[R]eplace current [w]ord" })

-- Address a few common mistakes I make when typing fast
-- vim.api.nvim_create_user_command("WQ", "wq", {})
-- vim.api.nvim_create_user_command("Wq", "wq", {})
vim.api.nvim_create_user_command("W", "w", {})
vim.api.nvim_create_user_command("Q", "q", {})

local wk = require("which-key")

-- wk.register({
--     sa = "Add surrounding",
--     sd = "Delete surrounding",
--     sh = "Highlight surrounding",
--     sn = "Surround update n lines",
--     sr = "Replace surrounding",
--     sF = "Find left surrounding",
--     sf = "Replace right surrounding"
-- })

-- wk.register({
--     f = {
--         name = "file", -- optional group name
--         f = {"<cmd>Telescope find_files<cr>", "Find File"} -- create a binding with label
--     }
-- }, {prefix = ""})

-- map('n', '<C-p>', [[<cmd> lua require('telescope.builtin').find_files()<CR>]],
--     default_options)
-- map('n', '<C-n>', ':NvimTreeToggle<CR>', default_options)
-- map('n', '<leader>r', ':NvimTreeRefresh<CR>', default_options)
-- map('n', '<C-s>', ':MarkdownPreview<CR>', default_options)
-- map('n', '<leader><Tab>', '<Plug>VimwikiNextLink', default_options)
-- map('n', '<leader><S-Tab>', '<Plug>VimwikiPrevLink', default_options)

wk.register({
    -- f = {
    --     name = "Find",
    --     f = { "<cmd>Telescope find_files<CR>", "Find file" },
    --     g = { "<cmd>Telescope git_files<CR>", "Find git files" },
    --     b = { "<cmd>Telescope buffers<CR>", "Find buffer" },
    --     r = { "<cmd>Telescope live_grep<CR>", "Find live grep" },
    -- },
    -- t = {
    --     name = "Test",
    --     n = { '<cmd>lua require("neotest").run.run()<CR>', "Run nearest" },
    --     d = {
    --         '<cmd>lua require("neotest").run.run({strategy = "dap"})<CR>',
    --         "Debug nearest",
    --     },
    --     f = {
    --         '<cmd>lua require("neotest").run.run(vim.fn.expand("%"))<CR>',
    --         "Run file",
    --     },
    --     s = { '<cmd>lua require("neotest").run.run({suite=true})<CR>', "Run suite" },
    -- },
    -- S = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
    -- w = {
    --     name = "Workspace",
    --     a = { "<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>", "Add workspace" },
    --     r = {
    --         "<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>",
    --         "Remove workspace",
    --     },
    --     l = {
    --         "<cmd>lua vim.lsp.buf.(list_workspace_folders)<CR>",
    --         "List workspaces",
    --     },
    -- },
    -- D = { "<cmd>lua vim.lsp.buf.type_definition()<CR>", "Type signature" },
    -- r = { n = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" } },
    g = {
        -- name = "Go to",
        -- r = { "<cmd>lua vim.lsp.buf.references()<CR>", "Go to reference" },
        -- d = { "<cmd>lua vim.lsp.buf.definition()<cr>", "Go to definition" },
        -- D = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Go to declaration" },
        -- i = {
        --     "<cmd>lua vim.lsp.buf.implementation()<CR>",
        --     "Go to implementation",
        -- },
        h = {
            name = "Git",
            s = { ":Gitsigns stage_hunk<CR>", "Stage hunk" },
            r = { ":Gitsigns reset_hunk<CR>", "Reset hunk" },
            S = { ":Gitsigns stage_buffer<CR>", "Stage buffer" },
            p = { ":Gitsigns preview_hunk<CR>", "Preview hunk" },
            u = { ":Gitsigns undo_stage_hunk<CR>", "Undo stage hunk" },
            b = { ":Gitsigns blame_line<CR>", "Blame line" },
            d = { ":Gitsigns diffthis<CR>", "Diff this" },
        },
    },
    -- c = {
    --     name = "Code",
    --     a = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Action" },
    --     f = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format" },
    --     r = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
    --     t = { "<cmd>StripWhitespace<CR>" },
    -- },
    -- l = {
    --     name = "LSP",
    --     f = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Format" },
    --     d = {
    --         "<cmd>lua vim.diagnostic.setloclist()<CR>",
    --         "List diagnostics in loclist",
    --     },
    --     D = {
    --         "<cmd>lua vim.diagnostic.open_float()<CR>",
    --         "List diagnostics in float",
    --     },
    -- },
    -- b = {
    --     name = "Buffers",
    --     n = { ":bnext<CR>", "Go to next buffer" },
    --     p = { ":bprev<CR>", "Go to previous buffer" },
    -- },
    -- ["\\"] = { ":vsplit<CR>", "Split vertically" },
    -- ["-"] = { ":hsplit<CR>", "Split horizontally" },
}, { prefix = "<leader>" })

-- wk.register({
--     g = {
--         name = "Go to",
--         r = {'<cmd>lua vim.lsp.buf.references()<CR>', 'Go to reference'},
--         d = {"<cmd>lua vim.lsp.buf.definition()<CR>", "Go to definition"},
--         D = {'<cmd>lua vim.lsp.buf.declaration()<CR>', "Go to declaration"},
--         i = {
--             '<cmd>lua vim.lsp.buf.implementation()<CR>', "Go to implementation"
--         }
--     },
--     K = {'<cmd>lua vim.lsp.buf.hover()<CR>', 'Hover documentation'},
--     ["]d"] = {
--         '<cmd>lua vim.diagnostic.goto_next()<CR>', "Go to next diagnostic"
--     },
--     ["[d"] = {
--         '<cmd>lua vim.diagnostic.goto_prev()<CR>', "Go to previous diagnostic"
--     },
--     ["<Tab>"] = {'<Plug>(cokeline-focus-next)', "Go to next buffer"},
--     ["<S-Tab>"] = {'<Plug>(cokeline-focus-prev)', "Go to previous buffer"}
-- })
