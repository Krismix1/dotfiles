local M = {
    "mrcjkb/rustaceanvim",
    version = "^4",
    ft = { "rust" },
    config = function()
        local lsp_utils = require("core.plugins.lsp.utils")
        vim.g.rustaceanvim = {
            -- Plugin configuration
            tools = {},
            -- LSP configuration
            server = {
                on_attach = function(client, bufnr)
                    lsp_utils.custom_lsp_attach(client)
                    lsp_utils.keybindings(bufnr)
                    -- TODO: More bindings https://github.com/mrcjkb/rustaceanvim?tab=readme-ov-file#usage
                end,
                default_settings = {
                    -- rust-analyzer language server configuration
                    ["rust-analyzer"] = {},
                },
            },
            -- DAP configuration
            dap = {},
        }
    end,
}

return M
