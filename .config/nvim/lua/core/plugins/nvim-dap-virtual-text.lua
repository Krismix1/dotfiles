-- debugging setup
local M = {
    "theHamsta/nvim-dap-virtual-text",
    config = function()
        require("nvim-dap-virtual-text").setup()
    end,
}

return M
