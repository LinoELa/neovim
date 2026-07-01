-- Opciones de Neovim (se cargan antes de lazy.nvim)
-- Defaults LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Nerd Font para iconos (LazyVim, blink, snacks). Terminal: JetBrainsMono NFM
vim.opt.guifont = "JetBrainsMono NFM:h14"

vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.cursorline = true
vim.opt.wrap = false

vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.softtabstop = 2
vim.opt.expandtab = true

vim.opt.clipboard = "unnamedplus"
vim.opt.swapfile = false
if vim.fn.has("win32") == 1 then
  -- Windows: usar PowerShell
  vim.opt.shell = "powershell.exe"
  vim.opt.shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
else
  -- Linux/VM: usar bash
  vim.opt.shell = "bash"
  vim.opt.shellcmdflag = "-c"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
end

vim.diagnostic.config({
  virtual_text = true,
  float = {
    source = "always",
  },
})

vim.opt.spell = false
vim.opt.spelllang = { "es", "en" }
