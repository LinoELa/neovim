# Mason

<!-- Notas del gestor de binarios LSP. Config: lsp.lua (mason-lspconfig) -->

Mason instala servidores LSP, linters y formatters. LazyVim ya incluye `mason.nvim`; no hace falta `mason.lua` aparte.

## Comandos

| Comando            | Qué hace                                      |
|--------------------|-----------------------------------------------|
| `:Mason`           | Abre la UI para instalar/desinstalar paquetes |
| `:MasonInstallAll` | Instala todo lo de `ensure_installed`         |

Dentro de `:Mason`:

- `i` — instalar el paquete seleccionado
- `X` — desinstalar
- `U` — actualizar

## Auto-instalación

En `lsp.lua` → `mason-lspconfig.nvim` → `ensure_installed`:

- `lua_ls`, `vtsls`, `rust_analyzer`, `pyright`

TypeScript/JS usa **vtsls** (extra LazyVim en `lazyvim.json`), no `ts_ls`.
