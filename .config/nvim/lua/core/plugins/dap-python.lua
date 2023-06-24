-- debugging setup
local M = {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
        "mfussenegger/nvim-dap",
    },
    config = function(_, opts)
        -- local path = "~/.local/share/nvim/mason/packages/debugpy/venv/bin/python"
        -- require("dap-python").setup(path)
        require("dap-python").setup(".venv/bin/python")
        -- Throws an error when loading. Circular dependency?
        -- local lsp_utils = require("core.plugins.lsp.utils")
        -- local path = lsp_utils.get_python_path("")
        -- require("dap-python").setup(path)
        require("dap-python").test_runner = "pytest"
    end,
}

return M
