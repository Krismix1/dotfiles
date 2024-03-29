-- fast statusline with good theming/lsp support
local lint_progress = function()
  local linters = require("lint").get_running()
  if #linters == 0 then
      return "󰦕"
  end
  return "󱉶 " .. table.concat(linters, ", ")
end

local M = {
    "nvim-lualine/lualine.nvim",
    config = function()
        local settings = require("core.settings")
        require("lualine").setup({
            options = {
                theme = settings.theme,
                icons_enabled = true,
                component_separators = "|",
                section_separators = "",
            },
            sections = {
                lualine_a = { "mode" },
                lualine_b = { "branch" },
                -- lualine_c = {'filename'},
                lualine_x = {
                    {
                        "copilot",
                        symbols = {
                            status = {
                                icons = {
                                    sleep = " 󰒲", -- auto-trigger disabled
                                },
                                hl = {
                                    sleep = "#077E8C",
                                },
                            },
                        },
                        show_colors = true,
                        show_loading = true,
                    },
                    { "diagnostics", sources = { "nvim_diagnostic" } },
                    "filetype",
                },
                lualine_y = { lint_progress },
                lualine_z = { "location" },
            },
        })
    end,
}

return M
