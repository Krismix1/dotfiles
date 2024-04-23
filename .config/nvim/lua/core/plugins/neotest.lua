-- plugin for adding unit test support
local M = {
    "nvim-neotest/neotest",
    dependencies = {
        "nvim-neotest/nvim-nio",
        "nvim-lua/plenary.nvim",
        "nvim-treesitter/nvim-treesitter",
        "antoinemadec/FixCursorHold.nvim",
        "nvim-neotest/neotest-python",
        "nvim-neotest/neotest-plenary", -- Debug setup
        "mfussenegger/nvim-dap",
        "mfussenegger/nvim-dap-python",
        "haydenmeade/neotest-jest",
    },
    config = function()
        -- TODO still not working perfectly and missing some keybinds
        require("neotest").setup({
            output = { enabled = true },
            adapters = {
                require("neotest-python")({
                    args = {
                        "--integration", --[[ "--integration-skip-ready", ]]
                        "-vv",
                    },
                    dap = {
                        justMyCode = false,
                        console = "integratedTerminal",
                    },
                    runner = "pytest",
                }),
                -- require("neotest-jest")({
                --     jestCommand = "npm test --",
                --     jestConfigFile = "custom.jest.config.ts",
                --     env = { CI = true },
                --     cwd = function(path)
                --         return vim.fn.getcwd()
                --     end,
                -- }),
                require("rustaceanvim.neotest"),
                require("neotest-plenary"),
            },
        })

        local ntest = require("neotest")
        vim.keymap.set("n", "<leader>tn", ntest.run.run, { desc = "Run nearest test" })
        vim.keymap.set("n", "<leader>td", function()
            ntest.run.run({ strategy = "dap", suite = false })
        end, { desc = "Debug nearest" })
        vim.keymap.set("n", "<leader>tf", function()
            ntest.run.run(vim.fn.expand("%"))
        end, { desc = "Run file" })
        vim.keymap.set("n", "<leader>ts", function()
            ntest.run.run({ suite = true })
        end, { desc = "Run suite" })

        local neotest_output = function()
            ntest.output_panel.toggle()
            ntest.summary.toggle()
        end
        vim.keymap.set("n", "<leader>to", neotest_output, { desc = "Toggle neotest output" })
    end,
}

return M
