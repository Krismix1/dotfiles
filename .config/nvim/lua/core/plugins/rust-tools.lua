local M = {
    "simrat39/rust-tools.nvim",
    dependencies = { "neovim/nvim-lspconfig", "nvim-lua/plenary.nvim", "mfussenegger/nvim-dap" },
    ft = "rust",
    lazy = true,
    config = function()
        local rt = require("rust-tools")
        local lsp_utils = require("core.plugins.lsp.utils")

        local capabilities = vim.lsp.protocol.make_client_capabilities()
        -- enable completion with cmp
        capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

        rt.setup({
            tools = {
                -- TODO: Doesn't seem to work...
                -- https://github.com/simrat39/rust-tools.nvim/issues/250#issuecomment-1272264132
                executor = require("rust-tools/executors").termopen,
                runnables = {
                    use_telescope = true,
                },
            },
            server = {
                capabilities = capabilities,
                on_attach = function(client, bufnr)
                    lsp_utils.custom_lsp_attach(client)
                    lsp_utils.keybindings(bufnr)

                    -- Code action groups
                    vim.keymap.set(
                        "n",
                        "<leader>ca",
                        rt.code_action_group.code_action_group,
                        { buffer = bufnr, silent = true, desc = "Rust Code Action Group" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cMe",
                        rt.expand_macro.expand_macro,
                        { buffer = bufnr, silent = true, desc = "Rust Expand Macro" }
                    )
                    vim.keymap.set(
                        "n",
                        "<leader>cG",
                        rt.crate_graph.view_crate_graph,
                        { buffer = bufnr, silent = true, desc = "View Crate Graph" }
                    )
                end,
                --     file_types = { "rust" },
                --     root_dir= "",
                --     flags = { debounce_text_changes = 150 },
                settings = {
                    -- to enable rust-analyzer settings visit:
                    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
                    ["rust-analyzer"] = {
                        cargo = {
                            allFeatures = true,
                        },
                        -- enable clippy on save
                        checkOnSave = {
                            command = "clippy",
                        },
                    },
                },
            },
        })
    end,
}

return M
