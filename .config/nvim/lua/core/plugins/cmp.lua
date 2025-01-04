-- better completion support
-- functions for super tab like support
-- https://github.com/hrsh7th/nvim-cmp/wiki/Example-mappings#vim-vsnip
local has_words_before = function()
    if vim.api.nvim_get_option_value("buftype", {buf = 0}) == "prompt" then
        return false
    end
    local line, col = unpack(vim.api.nvim_win_get_cursor(0))
    return col ~= 0 and
               vim.api.nvim_buf_get_text(0, line - 1, 0, line - 1, col, {})[1]:match(
                   "^%s*$") == nil
end

local M = {
    "hrsh7th/nvim-cmp",
    dependencies = {
        {
            -- snippet plugin
            "L3MON4D3/LuaSnip",
            dependencies = "rafamadriz/friendly-snippets",
            opts = {history = true, updateevents = "TextChanged,TextChangedI"},
            config = function(_, opts)
                require("core.plugins.configs.others").luasnip(opts)
            end
        }, "hrsh7th/cmp-nvim-lsp", "hrsh7th/cmp-path", "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-nvim-lua", "lukas-reineke/cmp-under-comparator",
        "onsails/lspkind-nvim", "hrsh7th/cmp-calc",
        "hrsh7th/cmp-nvim-lsp-signature-help", "saadparwaiz1/cmp_luasnip"
    },
    event = "InsertEnter",
    config = function()
        local cmp = require("cmp")
        local lspkind = require("lspkind")
        cmp.setup({
            snippet = {
                expand = function(args)
                    require("luasnip").lsp_expand(args.body)
                end
            },
            formatting = {
                format = lspkind.cmp_format({
                    mode = "symbol_text", -- show only symbol annotations
                    maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                    ellipsis_char = "...",
                    symbol_map = {Copilot = ""}
                })
            },
            mapping = cmp.mapping.preset.insert({
                ["<C-p>"] = cmp.mapping.select_prev_item(),
                ["<C-n>"] = cmp.mapping.select_next_item(),
                ["<C-b>"] = cmp.mapping.scroll_docs(-4),
                ["<C-f>"] = cmp.mapping.scroll_docs(4),
                ["<C-Space>"] = cmp.mapping.complete({}),
                ["<C-e>"] = cmp.mapping.abort(),
                ["<CR>"] = cmp.mapping.confirm({select = true}),
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif require("luasnip").expand_or_jumpable() then
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                            "<Plug>luasnip-expand-or-jump",
                                            true, true, true), "")
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        -- The fallback function sends a already mapped key.
                        -- In this case, it's probably `<Tab>`.
                        fallback()
                    end
                end, {"i", "s"}),

                ["<S-Tab>"] = cmp.mapping(function()
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif require("luasnip").jumpable(-1) then
                        vim.fn.feedkeys(vim.api.nvim_replace_termcodes(
                                            "<Plug>luasnip-jump-prev", true,
                                            true, true), "")
                    end
                end, {"i", "s"})
            }),
            sources = cmp.config.sources({
                {name = "copilot"}, {name = "nvim_lsp"}, {name = "luasnip"},
                {name = "buffer", keyword_length = 5}, {name = "path"},
                {name = "nvim_lua"}, {name = "nvim_lsp_signature_help"}
            }),
            sorting = {
                priority_weight = 2,
                comparators = {
                    cmp.config.compare.offset, cmp.config.compare.exact,
                    -- require("copilot_cmp.comparators").prioritize,
                    cmp.config.compare.score,
                    require("cmp-under-comparator").under,
                    cmp.config.compare.kind, cmp.config.compare.sort_text,
                    cmp.config.compare.length, cmp.config.compare.order
                }
            }
        })

        vim.api.nvim_set_hl(0, "CmpItemKindCopilot", {fg = "#6CC644"})
    end
}

return M
