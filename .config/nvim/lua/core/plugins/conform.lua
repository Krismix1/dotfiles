---@param bufnr integer
---@param ... string
---@return string
local function first(bufnr, ...)
    local conform = require("conform")
    for i = 1, select("#", ...) do
        local formatter = select(i, ...)
        if conform.get_formatter_info(formatter, bufnr).available then
            return formatter
        end
    end
    return select(1, ...)
end

local M = {
    "stevearc/conform.nvim",
    config = function()
        local utils = require("core.utils")
        require("conform").setup({
            formatters_by_ft = {
                lua = function(bufnr)
                    return {first(bufnr, "lua-format", "stylua")}
                end,
                python = function(bufnr)
                    if utils.exists("./.venv/bin/ruff") and
                        require("conform").get_formatter_info("ruff_fix", bufnr)
                            .available then
                        return {"ruff_fix", "black"}
                    else
                        return {"isort", "black"}
                    end
                end,
                javascript = function(bufnr)
                    return {first(bufnr, "prettierd", "prettier")}
                end,
                typescript = function(bufnr)
                    return {first(bufnr, "prettierd", "prettier")}
                end,
                html = function(bufnr)
                    return first(bufnr, "prettierd", "prettier")
                end,
                angular = function(bufnr)
                    return {first(bufnr, "prettierd", "prettier")}
                end,
                scss = function(bufnr)
                    return {first(bufnr, "prettierd", "prettier")}
                end,
                css = function(bufnr)
                    return {first(bufnr, "prettierd", "prettier")}
                end,
                yaml = function(bufnr)
                    return {first(bufnr, "prettierd", "prettier")}
                end,
                go = {"gofmt"},
                rust = {"rustfmt"},
                xml = {"xmllint"},
                json = {"jq"},
                sql = {"sql_formatter"}
            }
        })
    end
}

return M
