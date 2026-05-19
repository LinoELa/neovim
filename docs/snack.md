# snacks.nvim

<!-- Config: lua/plugins/snacks.lua | Atajos: docs/commandos-vim.md -->

Colección de utilidades (picker, explorador, notificaciones).

- Repo: https://github.com/folke/snacks.nvim

## Módulos activos

| Módulo     | Función |
|------------|---------|
| `picker`   | Buscar archivos, grep, buffers, historial |
| `explorer` | Árbol de archivos del proyecto |

## Atajos principales (`<leader>` = Espacio)

| Atajo | Función |
|-------|---------|
| `Espacio Espacio` | Buscar archivos (smart: buffers + recientes + archivos) |
| `Espacio e` | Explorador |
| `Espacio /` | Grep en el proyecto |
| `Espacio ,` | Lista de buffers |

Lista completa: `docs/commandos-vim.md`.

## Requisitos Windows

Instalar en PATH:

```powershell
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
```

Sin `fd`/`rg` el picker falla. Ver `docs/notas-problemas-soluciones.md`.

## Cambiar comportamiento

Editar `lua/plugins/snacks.lua`. Para buscar **todos** los archivos (estilo Ctrl+P) se puede usar `Snacks.picker.files()` en lugar de `smart()`.
