local M = {}

M.theme = "catppuccin"

M.treesitter_ensure_installed = {
    "bash",
    "c",
    "c_sharp",
    "comment",
    "cpp",
    "cpp",
    "css",
    "diff",
    "dockerfile",
    "gitignore",
    "go",
    -- "hcl",
    "help",
    "html",
    "java",
    "javascript",
    "jsonc",
    "latex",
    "lua",
    "markdown",
    "markdown_inline",
    "python",
    "query",
    "regex",
    -- "ruby",
    "rust",
    "scss",
    "toml",
    "typescript",
    "vim",
    "yaml",
}

M.mason_tool_installer_ensure_installed = {
    "bash-language-server",
    "black",
    "debugpy",
    "dockerfile-language-server",
    "eslint_d",
    "isort",
    "json-lsp",
    "lua-language-server",
    "marksman",
    -- "mypy",
    "prettier",
    "pydocstyle",
    "pylint",
    "pyright",
    "python-lsp-server",
    "ruff",
    -- "shellcheck",
    "shfmt",
    "stylua",
    "terraform-ls",
    "texlab",
    "tflint",
    "typescript-language-server",
    "yaml-language-server",
    "yamllint",
}

return M