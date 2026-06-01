-- Opciones de Neovim (se cargan antes de lazy.nvim)
-- Defaults LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Nerd Font para iconos (LazyVim, blink, snacks). Terminal: JetBrainsMono NFM
vim.opt.guifont = "JetBrainsMono NFM:h14"

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.wrap = false
vim.opt.expandtab = false
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
-- Usar PowerShell como shell de Neovim en Windows
vim.opt.shell = "powershell.exe"
vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
vim.opt.shellquote = ""
vim.opt.shellxquote = ""



vim.diagnostic.config({
    virtual_text = true,
    float = {
        source = "always"
    }
})
