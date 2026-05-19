# LSP (Language Server Protocol)

<!-- Config: lua/plugins/lsp.lua | Extra: lazyvim.json | Mason: docs/mason.md -->

Comunicación con servidores de lenguaje: autocompletado, errores, ir a definición, renombrar, etc.

## Archivos involucrados

| Archivo | Qué define |
|---------|------------|
| `lua/plugins/lsp.lua` | Servidores extra + `ensure_installed` de Mason |
| `lazyvim.json` | Extra `lang.typescript` → `vtsls` para TS/JS |
| LazyVim (interno) | Diagnósticos, atajos LSP, integración Mason |

## Servidores configurados

| Paquete Mason | Uso |
|---------------|-----|
| `vtsls` | TypeScript, JavaScript, TSX |
| `lua_ls` | Lua (esta config de Neovim) |
| `rust_analyzer` | Rust |
| `pyright` | Python |

Tras `:Lazy sync`, abrir `:Mason` e instalar los que falten.

## Comandos y atajos

| Atajo / comando | Uso |
|-----------------|-----|
| `Espacio c l` | Info LSP (Snacks) — **recomendado** |
| `:Mason` | Instalar/actualizar servidores |
| `:LspInfo` | Estado LSP (tras abrir un archivo) |
| `gra`, `grn`, `grr`… | Atajos globales Neovim — ver `commandos-vim.md` |

## Reglas importantes

1. **No** usar `config = function() vim.lsp.enable(...) end` en `lsp.lua` — pisa toda la config de LazyVim.
2. Solo ampliar con `opts` y `ensure_installed`.
3. El cursor debe estar **sobre el símbolo** para renombrar, referencias, etc.

## Primer arranque en un proyecto

```powershell
cd ruta\al\proyecto
nvim .
```

```vim
:Mason
```

Abrir un `.ts` o `.lua` y comprobar con `Espacio c l`.
