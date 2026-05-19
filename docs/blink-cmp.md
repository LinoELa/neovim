# blink.cmp

<!-- Config: lua/plugins/blink.lua -->

Autocompletado al escribir (sustituto moderno de nvim-cmp).

- Repo: https://github.com/saghen/blink.cmp
- Docs: https://cmp.saghen.dev/

## Qué hace

| Fuente   | Origen                          |
|----------|---------------------------------|
| `lsp`    | Servidor de lenguaje (Mason)    |
| `path`   | Rutas de archivos               |
| `snippets` | Plantillas (friendly-snippets) |
| `buffer` | Texto del buffer abierto        |

## Atajos (preset `super-tab`)

| Tecla | Acción |
|-------|--------|
| `Tab` | Siguiente sugerencia / aceptar |
| `Shift+Tab` | Anterior |
| `Ctrl+Space` | Abrir menú o documentación |
| `Ctrl+e` | Cerrar menú |

Preset tipo VS Code. Más opciones: `:h blink-cmp-config-keymap`.

## Requisitos

- Fuente **Nerd Font** en terminal para iconos (`appearance.nerd_font_variant = "mono"`).
- LSP activo para sugerencias de código (ver `docs/LSP.md`).

## Avisos del editor (lua_ls)

Si ves `not define annotate type: blink.cmp.Config`, es normal sin stubs del plugin. La config en `blink.lua` **no usa** `---@type` a propósito para evitar ese aviso.
