# Mason

<!-- Config: lua/plugins/lsp.lua (mason-lspconfig) | No crear mason.lua aparte -->

Instala y gestiona binarios: servidores LSP, linters, formatters.

- Repo: https://github.com/williamboman/mason.nvim

LazyVim ya incluye Mason. Esta config solo define **qué instalar** en `lsp.lua`.

## Comandos

| Comando | Acción |
|---------|--------|
| `:Mason` | Abrir interfaz |
| `:MasonInstall <nombre>` | Instalar uno |
| `:MasonInstallAll` | Instalar todo `ensure_installed` |

## Teclas dentro de `:Mason`

| Tecla | Acción |
|-------|--------|
| `i` | Instalar |
| `X` | Desinstalar |
| `U` | Actualizar paquete |
| `q` | Salir |

## Auto-instalación (`ensure_installed`)

Definido en `lua/plugins/lsp.lua`:

- `lua_ls`, `vtsls`, `rust_analyzer`, `pyright`

TypeScript usa **vtsls** (no `ts_ls`) gracias al extra en `lazyvim.json`.

## Si Mason no abre

El plugin carga en lazy. Abre un archivo de código o ejecuta `:Lazy` y comprueba que `mason.nvim` esté cargado. Ver `docs/notas-problemas-soluciones.md`.
