# Documentacion Neovim

Indice de notas de esta configuracion. Los archivos `.lua` viven en `lua/plugins/`; aqui solo se explica el comportamiento y el uso.

| Archivo | Contenido |
|---------|-----------|
| [commandos-vim.md](commandos-vim.md) | Atajos y comandos del dia a dia |
| [comandos-notion.md](comandos-notion.md) | Guia larga para copiar a Notion |
| [blink-cmp.md](blink-cmp.md) | Autocompletado |
| [snack.md](snack.md) | Picker y explorador |
| [LSP.md](LSP.md) | Language servers |
| [mason.md](mason.md) | Instalacion de binarios LSP |
| [treesitter.md](treesitter.md) | Parsers de sintaxis |
| [catppuccin.md](catppuccin.md) | Tema de colores |
| [notas-problemas-soluciones.md](notas-problemas-soluciones.md) | Errores frecuentes |
| [notes/@notes.md](notes/@notes.md) | Plugins, lazy, terminal |
| [notes/prompt-crear-todo-con-un-click.md](notes/prompt-crear-todo-con-un-click.md) | Prompt largo de instalacion |

## Flujo recomendado

La referencia principal ahora es el [README.md](../README.md) de la raiz del repo.

- Windows: `git pull` -> `.\scripts\setup.ps1`
- Linux: `git pull` -> `bash ./scripts/setup.sh`
- Docker: clonar o actualizar el repo y luego ejecutar `bash ./scripts/setup.sh`

Los scripts ya fuerzan la carga correcta de esta config en headless usando `NVIM_APPNAME` + `XDG_CONFIG_HOME`, asi que funcionan aunque la carpeta se llame `neovim` y no `nvim`.

## Mantenimiento

1. Cambiar config -> editar `lua/plugins/<nombre>.lua`
2. Documentar -> actualizar el `.md` correspondiente en `docs/`
3. Sincronizar -> ejecutar el script de setup o `:Lazy sync` dentro de Neovim

## No usar

- `lua/plugins/example.lua` -> plantilla LazyVim; no debe estar en este repo
