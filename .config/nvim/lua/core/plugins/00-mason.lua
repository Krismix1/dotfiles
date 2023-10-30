-- easy installation of lsps and integration with nvim
local settings = require("core.settings")

local M = {
    -- "williamboman/mason.nvim",
    -- cmd = "Mason",
    -- dependencies = {
    --   "williamboman/mason-lspconfig.nvim",
    --   "WhoIsSethDaniel/mason-tool-installer.nvim",
    -- },
    "jay-babu/mason-null-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "jose-elias-alvarez/null-ls.nvim",
    },
    config = function()
        require("mason").setup()
        require("mason-null-ls").setup({
            ensure_installed = settings.mason_tool_installer_ensure_installed,
            automatic_installation = true,
            automatic_setup = true, -- Recommended, but optional
            handlers = {},
            -- if set to true this will check each tool for updates. If updates
            -- are available the tool will be updated. This setting does not
            -- affect :MasonToolsUpdate or :MasonToolsInstall.
            -- Default: false
            auto_update = false,

            -- automatically install / update on startup. If set to false nothing
            -- will happen on startup. You can use :MasonToolsInstall or
            -- :MasonToolsUpdate to install tools and check for updates.
            -- Default: true
            run_on_start = true,

            -- set a delay (in ms) before the installation starts. This is only
            -- effective if run_on_start is set to true.
            -- e.g.: 5000 = 5 second delay, 10000 = 10 second delay, etc...
            -- Default: 0
            start_delay = 3000, -- 3 second delay
        })
        local nls = require("null-ls")
        nls.setup({
            sources = {
                -- Anything not supported by mason.
                nls.builtins.diagnostics.pylint.with({
                    cwd = function(params)
                        return vim.fn.fnamemodify(params.bufname, ":h")
                    end,
                    debounce = 1000,
                    prefer_local = ".venv/bin",
                    -- pylint is slow for big projects, let's give it up to 10s
                    timeout = 10000,
                    extra_args = {
                        "-d",
                        "missing-function-docstring",
                        "-d",
                        "invalid-name",
                        "-d",
                        "missing-module-docstring",
                        "-d",
                        "missing-class-docstring",
                        "-d",
                        "too-few-public-methods",
                        "-d",
                        "line-too-long",
                        "--extension-pkg-whitelist",
                        "pydantic,lxml",
                    },
                }),
                nls.builtins.formatting.black.with({
                    cwd = function(params)
                        return vim.fn.fnamemodify(params.bufname, ":h")
                    end,
                    prefer_local = ".venv/bin",
                }),
                nls.builtins.diagnostics.ruff,
                nls.builtins.formatting.xmllint,
                nls.builtins.diagnostics.mypy.with({
                    cwd = function(params)
                        return vim.fn.fnamemodify(params.bufname, ":h")
                    end,
                    prefer_local = ".venv/bin",
                }),
            },
        })
    end,
}

return M
