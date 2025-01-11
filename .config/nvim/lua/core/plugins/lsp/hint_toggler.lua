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

local function toggle_unnecessary_hints()
    show_unnecessary_hints = not show_unnecessary_hints

    -- There is probably a nicer way to refresh diagnostics (both from LSP & other tools) then restarting the client.
    -- But right now this is only needed for pyright, so it's a least something.
    -- By the time I need something more sophisticated, hopefully I'd know more about nvim APIs.
    vim.cmd("LspRestart")
end

local M = {}

M.setup = function()
    vim.lsp.handlers["textDocument/publishDiagnostics"] =
        custom_publish_diagnostics

    vim.keymap.set('n', '<leader>th', toggle_unnecessary_hints, {
        noremap = true,
        silent = true,
        desc = "[T]oggle Unnecessary [H]ints"
    })

end

return M
