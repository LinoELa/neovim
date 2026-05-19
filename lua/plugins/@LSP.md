# LSP

<!-- Notas LSP. Config real: lsp.lua + extra typescript en lazyvim.json -->

## Conceptos

- **LSP** — protocolo para autocompletado, diagnósticos, ir a definición, etc.
- **Mason** — instala los binarios de los servidores (ver `@mason.md`).

## Archivos de config

| Archivo        | Rol                                                |
|----------------|----------------------------------------------------|
| `lsp.lua`      | `ensure_installed` y servidores extra              |
| `lazyvim.json` | Extra `lang.typescript` → configura `vtsls`        |

## Servidores (trabajo habitual)

| Servidor        | Lenguajes              |
|-----------------|------------------------|
| `vtsls`         | TypeScript, JavaScript |
| `lua_ls`        | Lua (config Neovim)    |
| `rust_analyzer` | Rust                   |
| `pyright`       | Python                 |

## Comandos / atajos

| Atajo / comando | Uso                                      |
|-----------------|------------------------------------------|
| `Espacio c l`   | Info LSP (Snacks) — **el que funciona**  |
| `:Mason`        | Instalar servidores                      |
| `:LspInfo`      | Alternativa (a veces tras abrir un archivo) |

## Importante

No poner `config = function() vim.lsp.enable(...) end` en `lsp.lua`: rompe toda la config de LazyVim. Solo usar `opts`.
