# neovim

Configuración personal: **LazyVim** + plugins propios.

## Requisitos (Windows)

```powershell
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
```

- Fuente GUI: JetBrains Mono (`lua/config/options.lua`)
- Reiniciar terminal tras instalar `fd` / `rg`

## Estructura

```text
init.lua              → carga lazy.nvim
lua/config/           → opciones, keymaps, lazy
lua/plugins/          → plugins (*.lua) y notas (@*.md)
commandos-vim.md      → atajos que usamos
@notas-problemas-soluciones.md → troubleshooting
```

## Plugins propios

| Plugin / tema      | Archivo              | Notas              |
|--------------------|----------------------|--------------------|
| snacks.nvim        | `snacks.lua`         | `@snack.md`        |
| LSP + Mason        | `lsp.lua`            | `@LSP.md`, `@mason.md` |
| nvim-treesitter    | `nvim-treesitter.lua`| `@treesitter.md`   |
| catppuccin         | `catppuccin.lua`     | tema               |

## Primer uso en un proyecto

```powershell
cd ruta\al\proyecto
nvim .
```

```vim
:Lazy sync
:Mason
```

## Troubleshooting

Ver `@notas-problemas-soluciones.md`.
