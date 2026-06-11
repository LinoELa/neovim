-- Atajos globales extra (VeryLazy)
-- Defaults LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Atajos LSP de Neovim: docs/commandos-vim.md

local map = vim.keymap.set

map("n", "J", "6j", { desc = "Bajar 6 lineas" })
map("n", "K", "6k", { desc = "Subir 6 lineas" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
