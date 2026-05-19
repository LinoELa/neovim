# nvim-treesitter

<!-- Notas del plugin. Config real: nvim-treesitter.lua -->

Parser incremental para resaltado, indentación y navegación en el código.

- Repo: https://github.com/nvim-treesitter/nvim-treesitter

## Config

LazyVim usa la rama **main** (API nueva). En `nvim-treesitter.lua` solo ampliamos `ensure_installed`.

**No usar** `require("nvim-treesitter.configs")` — esa API ya no existe.

## Tras instalar o cambiar parsers

```vim
:TSUpdate
```

Si falla el checkout de parsers, ver `@notas-problemas-soluciones.md`.
