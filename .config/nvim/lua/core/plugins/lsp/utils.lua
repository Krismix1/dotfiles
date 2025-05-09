local M = {}

-- detect python venv
-- https://github.com/neovim/nvim-lspconfig/issues/500#issuecomment-851247107
function M.get_python_path(workspace)
    local util = require("lspconfig/util")
    local path = util.path
    -- Use activated virtualenv.
    if vim.env.VIRTUAL_ENV then
        return path.join(vim.env.VIRTUAL_ENV, "bin", "python")
    end

    local match = vim.fn.glob(path.join(workspace, ".venv"))
    if match ~= "" then return path.join(match, "bin", "python") end

    -- Fallback to system Python.
    return vim.fn.exepath("python3") or vim.fn.exepath("python") or "python"
end

function M.custom_lsp_attach(client)
    -- disable formatting for LSP clients as this is handled by null-ls
    client.server_capabilities.documentFormattingProvider = false
    client.server_capabilities.documentRangeFormattingProvider = false
end

--- @param bufnr integer
--- @param client vim.lsp.Client
function M.keybindings(bufnr, client)
    local nmap = function(keys, func, desc)
        if desc then desc = "LSP: " .. desc end

        vim.keymap.set("n", keys, func, {buffer = bufnr, desc = desc})
    end

    nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
    nmap("<leader>ca", "<cmd>CodeActionMenu<CR>", "[C]ode [A]ction")

    nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
    nmap("gr", require("telescope.builtin").lsp_references,
         "[G]oto [R]eferences")
    nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
    nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
    nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols,
         "[D]ocument [S]ymbols")
    nmap("<leader>ws",
         require("telescope.builtin").lsp_dynamic_workspace_symbols,
         "[W]orkspace [S]ymbols")

    -- See `:help K` for why this keymap
    nmap("K", vim.lsp.buf.hover, "Hover Documentation")
    nmap("<C-k>", vim.lsp.buf.signature_help, "Signature Documentation")

    nmap("<leader>f", function()
        require("conform").format({bufnr = bufnr, lsp_format = "fallback"})
    end, "[F]ormat buffer")

    -- Lesser used LSP functionality
    nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
    nmap("<leader>wa", vim.lsp.buf.add_workspace_folder,
         "[W]orkspace [A]dd Folder")
    nmap("<leader>wr", vim.lsp.buf.remove_workspace_folder,
         "[W]orkspace [R]emove Folder")
    nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, "[W]orkspace [L]ist Folders")

    if client.server_capabilities.inlayHintProvider then
        nmap("<leader>ht", function()
            -- https://github.com/nix-community/kickstart-nix.nvim/blob/6b28fa398a69b99318bde099fb9566eead5fa02e/nvim/plugin/autocommands.lua#L94
            local current_setting = vim.lsp.inlay_hint.is_enabled({
                bufnr = bufnr
            })
            vim.lsp.inlay_hint.enable(not current_setting, {bufnr = bufnr})
        end, "Toggle inlay [h]int")
        nmap("<leader>ha", function()

            local cursor_pos = vim.api.nvim_win_get_cursor(0)
            local function is_after_cursor(hint)
                return hint.position.line > cursor_pos[1] - 1 or
                           (hint.position.line == cursor_pos[1] - 1 and
                               hint.position.character > cursor_pos[2] - 1)
            end

            local hints = vim.lsp.inlay_hint.get({bufnr = bufnr})
            -- Find the first object that is after the cursor position
            for _, hint in ipairs(hints) do
                if hint.inlay_hint.kind == 1 and
                    is_after_cursor(hint.inlay_hint) then
                    local resp = client.request_sync('inlayHint/resolve',
                                                     hint.inlay_hint, 100, 0)
                    local resolved_hint = assert(resp and resp.result, resp.err)
                    if resolved_hint.textEdits ~= nil then
                        vim.lsp.util.apply_text_edits(resolved_hint.textEdits,
                                                      bufnr, "utf-8")
                        vim.api.nvim_win_set_cursor(0, {
                            hint.inlay_hint.position.line + 1, -- line is 0 based
                            -- character is 0 based, but we don't +1 on purpose so that it sets at the start of hint
                            hint.inlay_hint.position.character
                        })
                    else
                        vim.api.nvim_win_set_cursor(0, {
                            hint.inlay_hint.position.line + 1, -- line is 0 based
                            hint.inlay_hint.position.character + 1 -- character is 0 based
                        })
                        -- this can happen if the code would be invalid (e.g. hint is a variable declared in for loop)
                        vim.notify_once("Inlay hint missing text edit info",
                                        vim.log.levels.WARN)
                    end

                    break
                end
            end
        end, "[A]pply inlay [h]int")

    end

    vim.keymap.set("n", "<leader>mr", "<cmd>CellularAutomaton make_it_rain<CR>")

    local wk = require("which-key")
    wk.register({
        d = {
            name = "Debug",
            e = {
                name = "Execute",
                r = {"<cmd>RustLsp debuggables<CR>", "Rust"},
                p = {
                    function()
                        require("dap-python").test_method()
                    end, "Python"
                }
            },
            b = {
                name = "Breakpoints",
                l = {"<cmd> DapToggleBreakpoint <CR>", "Toggle Breakpoint Line"}
            },
            s = {
                name = "Step",
                n = {"<cmd> DapStepInto <CR>", "Next"},
                o = {"<cmd> DapStepOver <CR>", "Over"},
                O = {"<cmd> DapStepOut <CR>", "Out"},
                c = {"<cmd> DapContinue <CR>", "Continue"}
            },
            v = {
                name = "Views",
                s = {
                    function()
                        local widgets = require("dap.ui.widgets")
                        local sidebar = widgets.sidebar(widgets.scopes)
                        sidebar.open()
                    end, "Open debugging sidebar"
                }
            },
            Z = {"<cmd> DapTerminate <CR>", "Terminate"}
        }
    }, {prefix = "<leader>", mode = "n", buffer = bufnr})
end

return M
