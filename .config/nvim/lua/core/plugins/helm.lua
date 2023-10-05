-- https://github.com/mrjosh/helm-ls
local M = {
    "towolf/vim-helm",
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

        if not configs.helm_ls then
            configs.helm_ls = {
                default_config = {
                    cmd = { "helm_ls", "serve" },
                    filetypes = { "helm" },
                    root_dir = function(fname)
                        return util.root_pattern("Chart.yaml")(fname)
                    end,
                },
            }
        end

        lspconfig.helm_ls.setup({
            filetypes = { "helm" },
            cmd = { "helm_ls", "serve" },
            on_attach = function(client, bufnr)
                lsp_utils.custom_lsp_attach(client)
                lsp_utils.keybindings(bufnr)
            end,
            capabilities = capabilities,
        })
    end,
}
return M
