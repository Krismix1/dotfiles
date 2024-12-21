-- https://github.com/mrjosh/helm-ls
local M = {
    "Krismix1/vim-helm",
    dependencies = {
        "neovim/nvim-lspconfig",
    },
    ft = "helm",
    lazy = true,
    config = function()
        local configs = require("lspconfig.configs")
        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")
        local lsp_utils = require("core.plugins.lsp.utils")

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        lspconfig.helm_ls.setup({
            filetypes = { "helm" },
            cmd = { "helm_ls", "serve" },
            on_attach = function(client, bufnr)
                lsp_utils.custom_lsp_attach(client)
                lsp_utils.keybindings(bufnr, client)
            end,
            capabilities = capabilities,
            settings = {
                ["helm-ls"] = {
                    logLevel = "info",
                    valuesFiles = {
                        mainValuesFile = "values.yaml",
                        lintOverlayValuesFile = "",
                        additionalValuesFilesGlobPattern = "values.y?ml,/values/common.y?ml,/values/*development.y?ml",
                    },
                },
            },
        })
    end,
}
return M
