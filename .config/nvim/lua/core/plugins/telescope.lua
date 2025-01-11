-- quick fuzzy lookup of files
local M = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        {
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release && cmake --install build --prefix build",
        },
    },
    config = function()
        -- Telescope settings
        local telescope = require("telescope")
        local actions = require("telescope.actions")
        local additional_args = function(opts)
            return { "--hidden" }
        end
        telescope.setup({
            defaults = {
                path_display = {'truncate'},
                layout_strategy = 'vertical',
                layout_config = {
                    vertical = {
                        width = function(_, max_columns)
                            return math.floor(max_columns * 0.99)
                        end,
                        height = function(_, _, max_lines)
                            return math.floor(max_lines * 0.99)
                        end,
                        prompt_position = 'bottom',
                        preview_cutoff = 0
                    }
                },
                mappings = {
                    i = {
                        ["<C-v>"] = actions.select_vertical,
                        ["<C-h>"] = actions.select_horizontal,
                        ["<C-l>"] = actions.send_to_loclist,
                        ["<C-u>"] = false,
                        ["<C-d>"] = false,
                    },
                    n = {
                        q = actions.close,
                    },
                },
                file_ignore_patterns = { ".git/" },
                wrap_results = true,
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
            },
            pickers = {
                live_grep = {
                    additional_args = additional_args,
                },
                grep_string = {
                    additional_args = additional_args,
                },
            },
        })

        telescope.load_extension("fzf")
    end,
}
return M
