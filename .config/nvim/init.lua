vim.g.lua_snippets_path = vim.fn.stdpath("config") .. "/lua/snippets/"
require("core.lazy")
require("core.options")
require("core.autocmd")
require("core.mappings")
