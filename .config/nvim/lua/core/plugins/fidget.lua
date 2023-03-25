local M = {
    "j-hui/fidget.nvim",
    config = function()
        -- Turn on lsp status information
        require("fidget").setup({
            window = {
                blend = 0,
            },
        })
    end,
}
return M
