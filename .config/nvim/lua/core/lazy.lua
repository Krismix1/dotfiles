local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "--single-branch",
        "https://github.com/folke/lazy.nvim.git",
        lazypath,
    })
end
vim.opt.runtimepath:prepend(lazypath)

vim.keymap.set({ "n", "v" }, "<Space>", "<Nop>", { silent = true })
-- [[ Basic Keymaps ]]
-- Set <space> as the leader key
-- See `:help mapleader`
--  NOTE: Must happen before plugins are required (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup("core.plugins", {
    install = {
        -- install missing plugins on startup. This doesn't increase startup time.
        missing = true,
    },
    change_detection = {
        -- automatically check for config file changes and reload the ui
        enabled = false,
        notify = true, -- get a notification when changes are found
    },
    debug = false,
})
