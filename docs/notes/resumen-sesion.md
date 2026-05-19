# Resumen de sesión — Neovim config

> Guardado para retomar mañana. Repo: https://github.com/LinoELa/neovim

---

## Qué tenemos montado

- **LazyVim** + plugins: snacks, blink.cmp, LSP/Mason, treesitter, catppuccin
- **Ruta config:** `%LOCALAPPDATA%\nvim`
- **Extra TypeScript:** `lazyvim.json` → `vtsls`
- **Herramientas:** `fd`, `rg`, JetBrainsMono **NFM** (iconos)
- **Fuentes terminal:** Windows Terminal + Cursor → `JetBrainsMono NFM` 14

---

## Problemas que resolvimos

| Problema | Solución |
|----------|----------|
| Snacks no buscaba archivos | Instalar `fd` y `rg` |
| Iconos rotos | Nerd Font `JetBrainsMono NFM`, no JetBrains Mono normal |
| `nvim-treesitter.configs` not found | Solo `opts` en `nvim-treesitter.lua`, no API vieja |
| LSP/Mason rotos | Quitar `lsp.lua` con `vim.lsp.enable`; solo `opts` |
| `:LspInfo` no iba | Usar **`Espacio c l`** |
| lua_ls avisos blink/example | Sin `---@type`; borrar `example.lua` |

---

## Archivos clave

| Archivo | Para qué |
|---------|----------|
| `docs/comandos-notion.md` | **Todos los atajos** (copiar a Notion) |
| `docs/commandos-vim.md` | Atajos en el repo |
| `docs/notas-problemas-soluciones.md` | Troubleshooting |
| `docs/notes/prompt-crear-todo-con-un-click.md` | Montar todo tras `git pull` |
| `lua/plugins/*.lua` | Config plugins |

---

## Atajos que más usas

| Atajo | Acción |
|-------|--------|
| `Ctrl + /` | Terminal en **Cursor** |
| `Espacio Espacio` | Buscar archivos |
| `Espacio e` | Explorador |
| `Espacio /` | Grep |
| `Espacio c l` | Info LSP |
| `:Mason` | Instalar LSP |
| `Tab` | Autocompletado |
| `gd`, `grn`, `]d` | LSP / diagnósticos |

---

## Mañana (si retomas)

1. `git pull` en `%LOCALAPPDATA%\nvim`
2. Si máquina nueva → ejecutar `docs/notes/prompt-crear-todo-con-un-click.md` con el agente
3. `nvim .` → `:Lazy sync` → `:Mason` → `:TSUpdate`

---

## Último commit relevante

`ece4ebc` — configuración + `comandos-notion.md`

---

*Hasta mañana.*
