# neovim

Configuración personal basada en **LazyVim** (Windows).

## Requisitos

```powershell
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
```

- Fuente: **JetBrains Mono** (tamaño 14 en terminal y editor)
- Reiniciar terminal después de instalar `fd` / `rg`

## Estructura del repo

```text
init.lua                 → entrada
lua/config/              → options, keymaps, lazy bootstrap
lua/plugins/*.lua        → plugins (código)
docs/                    → documentación (leer docs/README.md)
lazyvim.json             → extras LazyVim (TypeScript, etc.)
```

## Plugins propios

| Plugin | Archivo | Documentación |
|--------|---------|---------------|
| snacks.nvim | `snacks.lua` | [docs/snack.md](docs/snack.md) |
| blink.cmp | `blink.lua` | [docs/blink-cmp.md](docs/blink-cmp.md) |
| LSP + Mason | `lsp.lua` | [docs/LSP.md](docs/LSP.md) |
| treesitter | `nvim-treesitter.lua` | [docs/treesitter.md](docs/treesitter.md) |
| catppuccin | `catppuccin.lua` | tema oscuro/claro |

## Primer uso

```powershell
cd ruta\al\proyecto
nvim .
```

```vim
:Lazy sync
:Mason
:TSUpdate
```

Atajos: [docs/commandos-vim.md](docs/commandos-vim.md).

## Problemas frecuentes

[docs/notas-problemas-soluciones.md](docs/notas-problemas-soluciones.md)

## Producción / mantenimiento

1. No añadir `lua/plugins/example.lua` (plantilla LazyVim).
2. Plugins nuevos → solo `lua/plugins/<nombre>.lua` + doc en `docs/`.
3. No importar plugins en `init.lua` (ver [docs/notes/@notes.md](docs/notes/@notes.md)).
4. Tras cambios: `:Lazy sync` y commit del repo.
