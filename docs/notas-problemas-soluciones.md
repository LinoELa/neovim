# Notas: problemas y soluciones (Neovim / Snacks)

---

## Smart picker no encuentra todos los archivos

**Descripción:** `<leader><space>` con `Snacks.picker.smart()` prioriza buffers y recientes; no equivale a Ctrl+P.

**Solución:** Usar `Snacks.picker.files()` para buscar todo el proyecto. Se dejó `smart()` como estaba.

---

## Snacks: "No supported finder found: fd"

**Descripción:** Al buscar en picker o explorador, Snacks no puede listar archivos del proyecto.

**Solución:** Instalar fd: `winget install sharkdp.fd`. Reiniciar terminal.

---

## Snacks: "Failed to spawn rg"

**Descripción:** Grep y búsquedas de texto fallan; no encuentra ripgrep.

**Solución:** Instalar ripgrep: `winget install BurntSushi.ripgrep.MSVC`. Reiniciar terminal.

---

## Snacks: fallo del comando `find`

**Descripción:** En Windows, `find` no es el de Linux; Snacks falla si no hay `fd`.

**Solución:** Instalar `fd` (arriba). No depender de `find` en Windows.

---

## Error al abrir archivo desde picker/explorer (treesitter)

**Descripción:** `No handler for set-lang-from-info-string!` al abrir un archivo; falla en `snacks.scope` / `snacks.indent`.

**Solución:** En Neovim: `:Lazy sync` y `:TSUpdate`. Si persiste, borrar caché: `Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim-data\lazy\nvim-treesitter"` y volver a sincronizar.

---

## nvim-treesitter: error al hacer checkout (pathspec master)

**Descripción:** Al instalar parsers: `error: pathspec 'master' did not match any file(s) known to git`.

**Solución:** Borrar carpeta `nvim-treesitter` en `nvim-data\lazy`, reiniciar Neovim y ejecutar `:Lazy sync` + `:TSUpdate`.

---

## Abrir Neovim fuera de la raíz del proyecto

**Descripción:** Búsqueda de archivos vacía o incorrecta si no se abre desde el directorio del proyecto.

**Solución:** `cd` al proyecto y `nvim .` (ej. `osaccess2-web`).

---

## Comprobar herramientas en terminal

**Descripción:** Verificar que fd y rg están disponibles tras instalar.

**Solución:** En PowerShell (terminal nueva): `fd --version` y `rg --version`.

---

## nvim-treesitter: `module 'nvim-treesitter.configs' not found`

**Descripción:** Al iniciar Neovim: `Failed to run config for nvim-treesitter` en `nvim-treesitter.lua`. Se usa `require("nvim-treesitter.configs")`, API antigua.

**Solución:** No usar `nvim-treesitter.configs`. Extender LazyVim solo con `opts` y `ensure_installed`. LazyVim usa `require("nvim-treesitter").setup(opts)`.

---

## Plugins en `:Lazy` como "Not Loaded"

**Descripción:** Mason, nvim-lspconfig, catppuccin, etc. aparecen como ○ Not Loaded al abrir Neovim.

**Solución:** Es normal (lazy-loading). Se cargan al abrir un archivo, usar un atajo o un comando (`:Mason`, abrir `.ts`, etc.). No hace falta importarlos en `init.lua`.

---

## ¿Importar Mason/LSP en `init.lua`?

**Descripción:** Dudas si hay que hacer `require` o import manual de mason/lsp en `init.lua`.

**Solución:** No. Con LazyVim, `lua/config/lazy.lua` ya hace `import = "plugins"`. Los archivos en `lua/plugins/*.lua` se cargan solos.

---

## `lsp.lua` rompe Mason y todo el LSP

**Descripción:** `:Mason` o LSP no funcionan bien. Había un `config` con solo `vim.lsp.enable({"ts_ls"})` que reemplazaba la config de LazyVim.

**Solución:** No usar `config` que pise LazyVim. Solo `opts` (p. ej. `servers`, `ensure_installed`). Dejar que LazyVim configure mason-lspconfig, diagnósticos y atajos.

---

## `mason.lua` duplicado e inútil

**Descripción:** Archivo con solo `mason.nvim` y `opts = {}` sin `mason-lspconfig`.

**Solución:** Eliminar `mason.lua`. Mason ya viene en LazyVim. Si hace falta, poner `ensure_installed` en `lsp.lua` vía `mason-lspconfig.nvim`.

---

## `:LspInfo` no funciona o "comando no encontrado"

**Descripción:** `:LspInfo` (o `:lspInfo`) no responde al abrir Neovim.

**Solución:** Usar **`Espacio c l`** (`<leader>cl`) — es lo que sí funciona en esta config (picker LSP de Snacks). Alternativa: abrir un `.ts`/`.lua` y luego `:LspInfo` o `:checkhealth vim.lsp`.

---

## Sin LSP en TypeScript / JavaScript

**Descripción:** No hay autocompletado ni diagnósticos en `.ts`/`.tsx`.

**Solución:** Activar extra en `lazyvim.json`: `"lazyvim.plugins.extras.lang.typescript"`. `:Lazy sync`, `:Mason`, instalar `vtsls`. Abrir un archivo TS para que arranque el servidor.

---

## Mason: servidores no instalados

**Descripción:** LSP configurado pero sin binarios; Mason vacío o sin instalar.

**Solución:** `:Mason` → instalar `vtsls`, `lua_ls`, etc. O en config: `mason-lspconfig` con `ensure_installed`. Luego reiniciar Neovim o reabrir el buffer.

---

## Comandos útiles LSP / Mason

**Descripción:** Referencia rápida de comandos.

**Solución:** `Espacio c l` (info LSP, **recomendado**), `:Mason` (instalar tools), `:LspInfo` / `:checkhealth vim.lsp` (alternativa), `:Lazy sync` (sincronizar plugins).

---

## lua_ls: avisos en `blink.lua` o `example.lua`

**Descripción:** En el editor: `not define annotate type: blink.cmp.Config`, `cmp.ConfigSchema`, `duplicate annotate type: PluginLspOpts`.

**Solución:** En `blink.lua` no usar `---@type blink.cmp.Config`. Borrar `lua/plugins/example.lua` si existe (plantilla LazyVim; no debe estar en el repo). Cerrar pestaña sin guardar si solo está abierta en el editor. `.luarc.json` en la raíz del config desactiva esos avisos.

---

## Iconos rotos o cuadrados en Neovim

**Descripción:** En picker, LSP, blink o diagnósticos aparecen `?`, cuadrados o símbolos raros en lugar de iconos.

**Solución:** Instalar Nerd Font: `winget install DEVCOM.JetBrainsMonoNerdFont`. En Windows Terminal y Cursor usar fuente `JetBrainsMono NFM` (no `JetBrains Mono` normal). Reiniciar terminal. En Neovim: `lua/config/options.lua` → `guifont = "JetBrainsMono NFM:h14"`.
