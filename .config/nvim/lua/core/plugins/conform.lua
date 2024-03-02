local M = {
    "stevearc/conform.nvim",
    config = function()
        local utils = require("core.utils")
        require("conform").setup({
            formatters_by_ft = {
                lua = { { "lua-format", "stylua" } },
                python = function(bufnr)
                    if
                        utils.exists("./.venv/bin/ruff")
                        and require("conform").get_formatter_info("ruff_fix", bufnr).available
                    then
                        return { "ruff_fix", "black" }
                    else
                        return { "isort", "black" }
                    end
                end,
                -- run only first available
                javascript = { { "prettierd", "prettier" } },
                typescript = { { "prettierd", "prettier" } },
                html = { { "prettierd", "prettier" } },
                scss = { { "prettierd", "prettier" } },
                css = { { "prettierd", "prettier" } },
                yaml = { { "prettierd", "prettier" } },
                go = { "gofmt" },
                rust = { "rustfmt" },
                xml = { "xmllint" },
                json = { "jq" },
                sql = { "sql_formatter" },
            },
        })
        vim.o.formatexpr = "v:lua.require'conform'.formatexpr( lsp_fallback = true )"
    end,
}

return M
