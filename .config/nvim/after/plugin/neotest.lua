local utils = require("core.plugins.lsp.utils")
local python_path = utils.get_python_path("./")
require('dap-python').setup(python_path)
require('dap-python').test_runner = 'pytest'

require("neotest").setup({
    output = { enabled = true },
    adapters = {
        require("neotest-python")({
            args = { "--integration" },
            dap = {
                justMyCode = false,
                console = "integratedTerminal"
            },
            runner = "pytest"
        }),
        require("neotest-plenary"),
    }
})
-- TODO: Add keybindings
-- https://github.com/nvim-neotest/neotest#usage
--Run the nearest test
-- require("neotest").run.run()
-- Run the current file
-- require("neotest").run.run(vim.fn.expand("%"))
-- Debug the nearest test (requires nvim-dap and adapter support)
-- require("neotest").run.run({strategy = "dap"})
-- See :h neotest.run.run() for parameters.
-- Stop the nearest test, see :h neotest.run.stop()
-- require("neotest").run.stop()
-- Attach to the nearest test, see :h neotest.run.attach()
-- require("neotest").run.attach()
-- :h neotest.output
-- :h neotest.output_panel
-- :h neotest.summary
