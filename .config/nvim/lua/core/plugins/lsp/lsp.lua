local nvim_lsp = require("lspconfig")
local util = require("lspconfig.util")
local lsp_utils = require("core.plugins.lsp.utils")

local capabilities = vim.lsp.protocol.make_client_capabilities()
-- enable completion with cmp
capabilities = require("cmp_nvim_lsp").default_capabilities(capabilities)

local servers = {
    "bashls",
    "cssls",
    "dockerls",
    "gopls",
    "jsonls",
    "lua_ls",
    "lemminx",
    "marksman",
    "nxls", -- https://github.com/nrwl/nx-console/issues/2019
    "pyright",
    "terraformls",
    "texlab",
    "ts_ls",
    "yamlls",
}

-- this needs to be called before setting up lsps
require("mason").setup({})
require("mason-lspconfig").setup({automatic_installation = true})

for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup({
        on_attach = function(client, bufnr)
            lsp_utils.custom_lsp_attach(client)
            lsp_utils.keybindings(bufnr, client)
        end,
        before_init = function(_, config)
            if lsp == "pyright" then
                config.settings.python.pythonPath =
                    lsp_utils.get_python_path(config.root_dir)
            end
        end,
        capabilities = capabilities,
        flags = {debounce_text_changes = 150}
    })
end

nvim_lsp.angularls.setup({
    on_attach = function(client, bufnr)
        lsp_utils.custom_lsp_attach(client)
        lsp_utils.keybindings(bufnr, client)
    end,
    root_dir = util.root_pattern("angular.json", "project.json"), -- This is for monorepo's
    filetypes = {"angular.html", "typescript"},
    capabilities = capabilities,
    flags = {debounce_text_changes = 150}
})

vim.diagnostic.config({
    -- Enable underline, use default values
    signs = true,
    underline = true,
    virtual_text = {spacing = 0, prefix = "■"},
    update_in_insert = false,
    -- show the source of the diagnostic (looking at you pyright...)
    float = {source = true} -- or 'if_many', check `:help vim.diagnostic.config`
})

require("core.plugins.lsp.hint_toggler").setup()
