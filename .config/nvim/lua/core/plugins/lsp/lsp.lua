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

-- Flag to control the visibility of "Unnecessary" hints
local show_unnecessary_hints = true
--- Custom handler for diagnostics to filter out "Unnecessary" tagged hints.
---@param _ lsp.ResponseError?
---@param result lsp.PublishDiagnosticsParams
---@param ctx lsp.HandlerContext
-- @return nil: This function does not return a value.
local function custom_publish_diagnostics(_, result, ctx)
    if not result or not result.diagnostics then return end

    -- https://github.com/microsoft/pyright/issues/1118#issuecomment-1859280421
    -- Pyright doesn't provide a config to remove those for the LSP,
    -- but at the same time, the same hints are used to show "unused" code in different colors
    -- so it's nice to be able to show/hide them at runtime
    if not show_unnecessary_hints then
        -- filter out diagnostics with the "Unnecessary" tag
        local filtered_diagnostics = {}
        for _, diagnostic in ipairs(result.diagnostics) do
            if not diagnostic.tags or not vim.tbl_contains(diagnostic.tags, 1) then
                table.insert(filtered_diagnostics, diagnostic)
            end
        end
        result.diagnostics = filtered_diagnostics
    end

    vim.lsp.diagnostic.on_publish_diagnostics(_, result, ctx)
end

vim.lsp.handlers["textDocument/publishDiagnostics"] = custom_publish_diagnostics

local function toggle_unnecessary_hints()
    show_unnecessary_hints = not show_unnecessary_hints

    -- There is probably a nicer way to refresh diagnostics (both from LSP & other tools) then restarting the client.
    -- But right now this is only needed for pyright, so it's a least something.
    -- By the time I need something more sophisticated, hopefully I'd know more about nvim APIs.
    vim.cmd("LspRestart")
end

vim.keymap.set('n', '<leader>th', toggle_unnecessary_hints, {
    noremap = true,
    silent = true,
    desc = "[T]oggle Unnecessary [H]ints"
})
