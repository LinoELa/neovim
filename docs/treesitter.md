# nvim-treesitter

<!-- Config: lua/plugins/nvim-treesitter.lua -->

Parsers para resaltado, indentación y consultas de sintaxis.

- Repo: https://github.com/nvim-treesitter/nvim-treesitter

## Cómo está configurado

- LazyVim usa la rama **main** (API nueva).
- Este repo solo amplía `ensure_installed` con los lenguajes que usamos.
- **No** usar `require("nvim-treesitter.configs")` — API eliminada.

## Parsers instalados

Ver lista en `lua/plugins/nvim-treesitter.lua` (bash, lua, typescript, rust, python, etc.).

## Comandos útiles

| Comando | Acción |
|---------|--------|
| `:TSUpdate` | Actualizar/instalar parsers |
| `:TSInstall <lang>` | Instalar un parser |
| `:TSBufEnable highlight` | Forzar resaltado en buffer |

## Mantenimiento

Tras cambiar `ensure_installed`:

```vim
:Lazy sync
:TSUpdate
```

Si falla checkout (`pathspec master`), ver `docs/notas-problemas-soluciones.md`.
