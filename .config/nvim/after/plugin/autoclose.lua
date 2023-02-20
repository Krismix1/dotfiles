require("autoclose").setup({
    options = {
        disabled_filetypes = {},
        disable_when_touch = true,
    },
    keys = {
        ["<"] = { escape = true, close = true, pair = "<>" },
        ["|"] = { escape = true, close = true, pair = "||" },
    }
})
