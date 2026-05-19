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
