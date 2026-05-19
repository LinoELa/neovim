# Documentación Neovim

Índice de notas de esta configuración. Los `.lua` viven en `lua/plugins/`; aquí solo se explica.

| Archivo | Contenido |
|---------|-----------|
| [commandos-vim.md](commandos-vim.md) | Atajos y comandos que usamos |
| [blink-cmp.md](blink-cmp.md) | Autocompletado (Tab, fuentes) |
| [snack.md](snack.md) | Picker y explorador |
| [LSP.md](LSP.md) | Language servers |
| [mason.md](mason.md) | Instalar binarios LSP |
| [treesitter.md](treesitter.md) | Parsers de sintaxis |
| [catppuccin.md](catppuccin.md) | Tema de colores |
| [notas-problemas-soluciones.md](notas-problemas-soluciones.md) | Errores frecuentes |
| [notes/@notes.md](notes/@notes.md) | Plugins, lazy, terminal |
| [notes/prompt-crear-todo-con-un-click.md](notes/prompt-crear-todo-con-un-click.md) | **Prompt para montar todo tras `git pull`** |

## Mantenimiento

1. Cambiar config → editar `lua/plugins/<nombre>.lua`
2. Documentar → actualizar el `.md` correspondiente en `docs/`
3. Sincronizar → `:Lazy sync` dentro de Neovim

## No usar

- `lua/plugins/example.lua` — plantilla LazyVim; **no debe estar** en este repo (genera avisos de lua_ls).
