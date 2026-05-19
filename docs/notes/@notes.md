# Notas varias

Índice general de documentación: `docs/README.md`.

## ¿Hay que importar un plugin en init, options o lazy?

**No.** En esta config con LazyVim no hace falta importar cada plugin a mano.

### Flujo

```text
init.lua
  └── require("config.lazy")
        └── import = "plugins"   → carga todo lua/plugins/*.lua
```

Un archivo nuevo en `lua/plugins/`, por ejemplo `mi-plugin.lua`:

```lua
return {
  "autor/mi-plugin.nvim",
  opts = {},
}
```

Lazy.nvim lo detecta solo. **No** añadir `require` en `init.lua`.

### Dónde tocar cosas

| Sitio | Cuándo |
|-------|--------|
| `lua/plugins/mi-plugin.lua` | Casi siempre — definición del plugin |
| `lua/config/options.lua` | Opciones de Neovim (`vim.opt`), no plugins |
| `lua/config/keymaps.lua` | Atajos globales fuera del spec del plugin |
| `lazyvim.json` | Solo extras oficiales de LazyVim |
| `init.lua` | Solo arranque de lazy — no tocar por cada plugin |

### Resumen

- Plugin nuevo → `lua/plugins/nombre.lua`
- Reiniciar Neovim o `:Lazy` para instalar
- Extras de LazyVim (TypeScript, etc.) → `lazyvim.json` en `extras`

---

## Terminal: fuente que cambia sola (auto escala)

No hay un programa "AutoScale" en el PC; suele ser **zoom del terminal** o **DPI de Windows** (tienes 2 monitores).

### Dónde está el tamaño ahora

| Dónde | Archivo | Tamaño |
|-------|---------|--------|
| Windows Terminal | `%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json` | **JetBrainsMono NFM** 14 |
| Cursor (terminal) | `%APPDATA%\Cursor\User\settings.json` | **JetBrainsMono NFM** 14 |
| Neovim GUI | `lua/config/options.lua` | `JetBrainsMono NFM:h14` |

Montaje completo en máquina nueva: `docs/notes/prompt-crear-todo-con-un-click.md`.

### Si se agranda al abrir el terminal

1. **Restablecer zoom:** en la terminal enfocada, `Ctrl+0`.
2. **No usar** `Ctrl+` `+` / `Ctrl+` `-` (zoom de fuente).
3. **Dos monitores:** Configuración → Pantalla → misma **Escala** (%) en ambos.
4. Cierra y abre la terminal tras cambiar `settings.json`.
