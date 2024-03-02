local M = {
    "scalameta/nvim-metals",
    dependencies = { "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    -- ft = "scala",
    -- lazy = true,
    config = function()
        local configs = require("lspconfig.configs")
        local lspconfig = require("lspconfig")
        local util = require("lspconfig.util")
        local lsp_utils = require("core.plugins.lsp.utils")

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        local metals_config = require("metals").bare_config()
        metals_config.on_attach = function(client, bufnr)
            -- require("metals").setup_dap()
            lsp_utils.custom_lsp_attach(client)
            lsp_utils.keybindings(bufnr)

            -- local map = vim.keymap.set
            -- map("n", "gD", vim.lsp.buf.definition)
            -- map("n", "K", vim.lsp.buf.hover)
            -- map("n", "gi", vim.lsp.buf.implementation)
            -- map("n", "gr", vim.lsp.buf.references)
            -- map("n", "gds", vim.lsp.buf.document_symbol)
            -- map("n", "gws", vim.lsp.buf.workspace_symbol)
            -- map("n", "<leader>cl", vim.lsp.codelens.run)
            -- map("n", "<leader>sh", vim.lsp.buf.signature_help)
            -- map("n", "<leader>rn", vim.lsp.buf.rename)
            -- map("n", "<leader>f", vim.lsp.buf.format)
            -- map("n", "<leader>ca", vim.lsp.buf.code_action)
        end
        -- metals_config.capabilities = capabilities
        -- Example of settings
        metals_config.settings = {
            showImplicitArguments = true,
            excludedPackages = { "akka.actor.typed.javadsl", "com.github.swagger.akka.javadsl" },
        }

        -- https://github.com/scalameta/nvim-metals/discussions/39
        -- Autocmd that will actually be in charging of starting the whole thing
        local nvim_metals_group = vim.api.nvim_create_augroup("nvim-metals", { clear = true })
        vim.api.nvim_create_autocmd("FileType", {
            -- NOTE: You may or may not want java included here. You will need it if you
            -- want basic Java support but it may also conflict if you are using
            -- something like nvim-jdtls which also works on a java filetype autocmd.
            pattern = {
                "scala",
                "sbt", --[[ "java" ]]
            },
            callback = function()
                require("metals").initialize_or_attach(metals_config)
            end,
            group = nvim_metals_group,
        })
    end,
}
return M
