-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- JetBrains Mono normal (no Nerd Font). Solo aplica en Neovide/GVim.
-- En terminal, la fuente la define Windows Terminal (ver settings.json del terminal).
vim.opt.guifont = "JetBrains Mono:h14"
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false