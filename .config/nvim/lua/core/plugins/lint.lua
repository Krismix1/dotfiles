local prefer_venv_local = function(linter, lint_cmd)
    local utils = require("core.utils")
    local python_cmd = vim.fn.getcwd() .. "/.venv/bin/python"
    if utils.exists("./.venv/bin/" .. lint_cmd) then
        vim.notify_once("Running `" .. lint_cmd .. "` in .venv")
        linter.cmd = python_cmd
        linter.args = vim.list_extend({ "-m", lint_cmd }, linter.args)
    else
        vim.notify_once("Running `" .. lint_cmd .. " ` without .venv")
    end
end

local M = {
    "mfussenegger/nvim-lint",
    config = function()
        require("lint").linters_by_ft = {
            python = { "ruff", "mypy", "pylint" },
            typescript = { "eslint_d" },
            javascript = { "eslint_d" },
        }

        local pylint = require("lint").linters.pylint
        pylint.args = vim.list_extend(pylint.args, {
            "-d",
            "missing-function-docstring",
            "-d",
            "invalid-name",
            "-d",
            "missing-module-docstring",
            "-d",
            "missing-class-docstring",
            "-d",
            "W1514", -- open without explicit encoding
            "-d",
            "too-few-public-methods",
            "-d",
            "line-too-long",
        })

        local mypy = require("lint").linters.mypy
        mypy.args = vim.list_extend(mypy.args, {
            "--ignore-missing-imports",
            "--disable-error-code",
            "import-untyped",
        })

        local utils = require("core.utils")
        local venv = utils.exists("./.venv/") and "./.venv" or nil
        if venv then
            prefer_venv_local(mypy, "mypy")
            prefer_venv_local(require("lint").linters.ruff, "ruff")
            prefer_venv_local(pylint, "pylint")
        end

        local slow_linters = { "mypy", "pylint" }
        local all_but_slow = {}
        for key, values in pairs(require("lint").linters_by_ft) do
            values = vim.tbl_filter(function(linter)
                return not vim.tbl_contains(slow_linters, linter)
            end, values)
            all_but_slow[key] = values
        end

        vim.api.nvim_create_autocmd({ "BufWritePost", "BufWinEnter", "BufReadPost" }, {
            callback = function()
                require("lint").try_lint()
            end,
        })

        vim.api.nvim_create_autocmd({ "InsertLeave" }, {
            callback = function()
                require("lint").try_lint(all_but_slow[vim.bo.filetype])
            end,
        })
    end,
}

return M
