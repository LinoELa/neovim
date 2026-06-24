-- Atajos globales extra (VeryLazy)
-- Defaults LazyVim: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Atajos LSP de Neovim: docs/commandos-vim.md

local map = vim.keymap.set

map("n", "J", "6j", { desc = "Bajar 6 lineas" })
map("n", "K", "6k", { desc = "Subir 6 lineas" })
map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Buffer anterior" })
map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Buffer siguiente" })
map("n", "<A-Down>", ":m .+1<CR>==", { desc = "Mover linea abajo" })
map("n", "<A-Up>", ":m .-2<CR>==", { desc = "Mover linea arriba" })
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", { desc = "Mover seleccion abajo" })
map("v", "<A-Up>", ":m '<-2<CR>gv=gv", { desc = "Mover seleccion arriba" })

-- Si tu terminal no detecta Alt correctamente, prueba estas variantes:
-- map("n", "<C-Down>", ":m .+1<CR>==", { desc = "Mover linea abajo" })
-- map("n", "<C-Up>", ":m .-2<CR>==", { desc = "Mover linea arriba" })
-- map("v", "<C-Down>", ":m '>+1<CR>gv=gv", { desc = "Mover seleccion abajo" })
-- map("v", "<C-Up>", ":m '<-2<CR>gv=gv", { desc = "Mover seleccion arriba" })
