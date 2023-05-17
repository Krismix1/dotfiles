local M = {
    "saecki/crates.nvim",
    ft = {
        -- "rust",
        "toml",
    },
    dependencies = { "nvim-lua/plenary.nvim", "hrsh7th/nvim-cmp" },
    config = function(_, opts)
        local crates = require("crates")
        -- crates.setup(opts)
        crates.setup({
            null_ls = {
                enabled = true,
                name = "crates.nvim",
            },
            open_programs = { "firefox-developer-edition", "firefox", "xdg-open", "open" },
        })
        require("cmp").setup.buffer({
            sources = { { name = "crates" } },
        })
        crates.show()
        local nmap = function(keys, func, desc)
            if desc then
                desc = "Cargo: " .. desc
            end

            vim.keymap.set("n", keys, func, { silent = true, desc = desc })
        end

        nmap("K", crates.show_popup, "Crate Documentation")

        nmap("<leader>cv", crates.show_versions_popup, "Show versions popup")
        nmap("<leader>cf", crates.show_features_popup, "Show features popup")
        nmap("<leader>cd", crates.show_dependencies_popup, "Show dependencies popup")
        nmap("<leader>cH", crates.open_homepage, "Open homepage")
        nmap("<leader>cR", crates.open_repository, "Open repository")
        nmap("<leader>cD", crates.open_documentation, "Open documentation")
        nmap("<leader>cC", crates.open_crates_io, "Open the `crates.io` page of the crate")
    end,
}

return M
