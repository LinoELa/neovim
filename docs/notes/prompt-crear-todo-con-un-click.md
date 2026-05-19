# PROMPT: montar toda la configuración Neovim (un clic)

> **Para el agente (Cursor / IA):** El usuario hará `git pull` de este repo y te pedirá que **ejecutes este documento**. Debes hacer **todo** lo descrito: comprobar, instalar, configurar fuera del repo si hace falta, y verificar que Neovim queda operativo en Windows. **No te detengas** ante el primer error: diagnostica, corrige y sigue. Responde en **español**.

---

## 0. Contexto del proyecto

| Dato | Valor |
|------|--------|
| Repositorio | https://github.com/LinoELa/neovim.git |
| Rama | `main` |
| Qué es | Configuración completa de **Neovim + LazyVim** (no es un plugin suelto) |
| Ruta en Windows | `%LOCALAPPDATA%\nvim` → `C:\Users\<usuario>\AppData\Local\nvim` |
| Datos/plugins Lazy | `%LOCALAPPDATA%\nvim-data` |

**Stack configurado en este repo:**

- LazyVim (base)
- snacks.nvim (picker, explorador)
- blink.cmp (autocompletado)
- nvim-treesitter (parsers)
- Mason + LSP (vtsls, lua_ls, rust_analyzer, pyright)
- catppuccin (tema)
- Extra TypeScript en `lazyvim.json`

**Documentación del repo:** leer `docs/README.md`, `docs/notas-problemas-soluciones.md`, `docs/commandos-vim.md`.

---

## 1. Objetivo final (definición de “hecho”)

Al terminar, el usuario debe poder:

```powershell
cd C:\ruta\a\su\proyecto
nvim .
```

Y tener:

- [ ] Neovim abre sin errores críticos al inicio
- [ ] `:Lazy` muestra plugins instalados (snacks, blink, mason, treesitter, etc.)
- [ ] `Espacio Espacio` busca archivos (snacks; requiere `fd`)
- [ ] `Espacio /` hace grep (requiere `rg`)
- [ ] `Espacio e` abre explorador
- [ ] `:Mason` abre y puede instalar servidores
- [ ] `Espacio c l` muestra info LSP
- [ ] Iconos visibles (no cuadrados `?`) → Nerd Font **JetBrainsMono NFM**
- [ ] Autocompletado (blink) con `Tab`
- [ ] Archivo `lua/plugins/example.lua` **no existe**

---

## 2. Orden de ejecución (obligatorio)

Ejecutar en este orden. Usar **PowerShell** con permisos de red; winget puede pedir **administrador** para la fuente.

### Fase A — Sistema y herramientas

#### A.1 Comprobar / instalar Neovim

```powershell
nvim --version
```

Si falla:

```powershell
winget install Neovim.Neovim --accept-package-agreements --accept-source-agreements
```

Cerrar y reabrir terminal tras instalar.

#### A.2 Instalar `fd` (buscar archivos en snacks)

```powershell
fd --version
```

Si falla:

```powershell
winget install sharkdp.fd -e --accept-package-agreements --accept-source-agreements
```

#### A.3 Instalar `rg` / ripgrep (grep en snacks)

```powershell
rg --version
```

Si falla:

```powershell
winget install BurntSushi.ripgrep.MSVC -e --accept-package-agreements --accept-source-agreements
```

#### A.4 Instalar Nerd Font (iconos)

```powershell
winget install DEVCOM.JetBrainsMonoNerdFont -e --accept-package-agreements --accept-source-agreements
```

Comprobar en registro (debe listar fuentes `JetBrainsMono NFM`):

```powershell
Get-ItemProperty "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Fonts" |
  Get-Member -MemberType NoteProperty |
  Where-Object { $_.Name -match 'JetBrainsMono NFM' } |
  Select-Object -ExpandProperty Name
```

**Importante:** la fuente del repo es **`JetBrainsMono NFM`**, no `JetBrains Mono` normal.

---

### Fase B — Repositorio de configuración

#### B.1 Ubicación correcta

La carpeta de trabajo del agente debe ser la config de Neovim:

```powershell
$NVIM = "$env:LOCALAPPDATA\nvim"
Test-Path $NVIM
Test-Path "$NVIM\init.lua"
Test-Path "$NVIM\lua\config\lazy.lua"
```

#### B.2 Si el usuario acaba de clonar (máquina nueva)

Si `%LOCALAPPDATA%\nvim` no es un clone de git o está vacío:

```powershell
# Backup opcional
if (Test-Path $NVIM) { Rename-Item $NVIM "$NVIM.bak.$(Get-Date -Format 'yyyyMMdd')" }

git clone https://github.com/LinoELa/neovim.git $NVIM
```

#### B.3 Si el usuario hizo pull (máquina ya configurada)

```powershell
cd $env:LOCALAPPDATA\nvim
git pull origin main
git status
```

#### B.4 Archivos que DEBEN existir (comprobar)

```text
init.lua
lua/config/lazy.lua
lua/config/options.lua
lua/config/keymaps.lua
lua/plugins/snacks.lua
lua/plugins/blink.lua
lua/plugins/lsp.lua
lua/plugins/nvim-treesitter.lua
lua/plugins/catppuccin.lua
lazyvim.json
lazy-lock.json
.luarc.json
docs/commandos-vim.md
docs/notas-problemas-soluciones.md
```

#### B.5 Archivos que NO deben existir

- `lua/plugins/example.lua` → **eliminar** si existe (plantilla LazyVim; rompe LSP y genera avisos lua_ls)
- `lua/plugins/mason.lua` → no debe existir (Mason se configura en `lsp.lua`)
- `lua/plugins/@*.md` en `lua/plugins/` → la doc está en `docs/`, no en plugins

Si `example.lua` solo está abierto en el editor sin guardar, pedir al usuario cerrar la pestaña sin guardar.

---

### Fase C — Configuración fuera del repo (Windows)

Estos archivos **no están en git** del usuario o están en rutas del sistema. El agente debe **aplicar o verificar** que coinciden con lo esperado.

#### C.1 Windows Terminal — fuente Nerd Font, tamaño 14

**Archivo:**

`%LOCALAPPDATA%\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json`

En `profiles.defaults.font` debe quedar:

```json
"font": {
  "face": "JetBrainsMono NFM",
  "size": 14
}
```

Opcional (evitar zoom accidental): en `actions`, desvincular `ctrl+=`, `ctrl+-`, `ctrl+0` con `"command": "unbound"` si el usuario lo tenía configurado.

#### C.2 Cursor — terminal integrada (si usa Cursor)

**Archivo:**

`%APPDATA%\Cursor\User\settings.json`

Verificar o añadir:

```json
"terminal.integrated.fontSize": 14,
"terminal.integrated.fontFamily": "JetBrainsMono NFM",
"editor.fontSize": 14,
"editor.fontFamily": "JetBrains Mono"
```

(El editor puede seguir con JetBrains Mono; la **terminal** donde corre `nvim` debe ser **NFM**.)

#### C.3 Neovim `options.lua` (ya en el repo)

Debe contener:

```lua
vim.opt.guifont = "JetBrainsMono NFM:h14"
```

No cambiar a `JetBrains Mono` sin Nerd.

---

### Fase D — Primera sincronización dentro de Neovim

Tras instalar herramientas, **cerrar todas las ventanas de terminal** y abrir una nueva (PATH y fuentes).

#### D.1 Sincronizar plugins (headless)

```powershell
cd $env:LOCALAPPDATA\nvim
nvim --headless "+Lazy! sync" +qa 2>&1
```

Si falla, abrir Neovim interactivo y ejecutar `:Lazy sync` manualmente.

#### D.2 Mason — instalar servidores LSP

Abrir Neovim en un proyecto o en la carpeta config:

```powershell
cd C:\ruta\al\proyecto   # o $env:LOCALAPPDATA\nvim
nvim .
```

Dentro de Neovim (el usuario o el agente con comandos):

```vim
:MasonInstallAll
```

O instalar uno a uno si falla: `vtsls`, `lua_ls`, `rust_analyzer`, `pyright` (definidos en `lua/plugins/lsp.lua`).

#### D.3 Treesitter — parsers

```vim
:TSUpdate
```

Si error `pathspec master` en treesitter:

```powershell
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\nvim-data\lazy\nvim-treesitter" -ErrorAction SilentlyContinue
```

Luego en Neovim: `:Lazy sync` y `:TSUpdate`.

---

### Fase E — Verificaciones automáticas (agente)

Ejecutar y reportar resultado:

```powershell
fd --version
rg --version
nvim --version
```

En Neovim (headless o instrucciones al usuario):

```vim
:checkhealth lazy
:checkhealth mason
:checkhealth nvim-treesitter
```

Comprobar que **no** hay error:

- `module 'nvim-treesitter.configs' not found` → si aparece, `nvim-treesitter.lua` usa API vieja; debe usar solo `opts`, ver repo
- `Failed to run config for nvim-treesitter` por `configs` → corregir según `docs/treesitter.md`
- `No supported finder found: fd` → instalar fd y reiniciar terminal
- `Permission denied` en git push → no es bloqueante para uso local

**Prueba de iconos:** en terminal con NFM, pegar o mostrar: `󰈔` — debe verse un icono, no `?`.

---

## 3. Reglas de configuración (no romper)

### 3.1 Plugins

- **No** importar plugins en `init.lua` (solo `require("config.lazy")`).
- **No** crear `config = function() vim.lsp.enable(...) end` en `lsp.lua` — destruye LazyVim.
- Plugins nuevos → solo `lua/plugins/<nombre>.lua` con `return { ... }`.
- Extras LazyVim → `lazyvim.json` → `"lazyvim.plugins.extras.lang.typescript"` ya está.

### 3.2 blink.cmp

- Archivo: `lua/plugins/blink.lua`
- **No** usar `---@type blink.cmp.Config` (avisos lua_ls).
- `appearance.nerd_font_variant = "mono"` requiere fuente **JetBrainsMono NFM**.

### 3.3 Atajos principales (`<leader>` = Espacio)

Documentados en `docs/commandos-vim.md`:

| Atajo | Acción |
|-------|--------|
| `Espacio Espacio` | Buscar archivos (smart) |
| `Espacio e` | Explorador |
| `Espacio /` | Grep |
| `Espacio c l` | Info LSP |
| `:Mason` | Instalar LSP |
| `Tab` | Autocompletado (blink) |

### 3.4 LSP global Neovim (no confundir con leader)

`gra`, `grn`, `grr`, `]d`, `[d`, etc. — ver `docs/commandos-vim.md`. El cursor debe estar **sobre el símbolo**.

---

## 4. Estructura del repo (referencia rápida)

```text
%LOCALAPPDATA%\nvim\
├── init.lua
├── lazyvim.json          # extra TypeScript
├── lazy-lock.json
├── .luarc.json
├── lua/
│   ├── config/
│   │   ├── lazy.lua      # LazyVim + import plugins
│   │   ├── options.lua   # guifont NFM, diagnostics
│   │   ├── keymaps.lua
│   │   └── autocmds.lua
│   └── plugins/
│       ├── snacks.lua
│       ├── blink.lua
│       ├── lsp.lua
│       ├── nvim-treesitter.lua
│       └── catppuccin.lua
└── docs/
    ├── README.md
    ├── commandos-vim.md
    ├── notas-problemas-soluciones.md
    └── notes/
        ├── @notes.md
        └── prompt-crear-todo-con-un-click.md   # este archivo
```

---

## 5. Qué NO hacer

- **No** hacer `git push --force` a `main` salvo petición explícita.
- **No** commitear secretos (`.env`, API keys). El `settings.json` de Cursor del usuario puede tener secretos — no subirlo a este repo.
- **No** añadir `lua/plugins/example.lua`.
- **No** sustituir toda la config LSP de LazyVim con un `config` mínimo.
- **No** asumir que `find` de Linux existe en Windows — usar `fd`.
- **No** usar `JetBrains Mono` normal en terminal si se quieren iconos.

---

## 6. Mensaje final al usuario (plantilla)

Cuando termines, responde con:

1. **Checklist** de la sección 1 (marcar OK / fallo).
2. **Qué instalaste** (fd, rg, Nerd Font, Neovim).
3. **Qué archivos fuera del repo tocaste** (Terminal, Cursor).
4. **Comandos que debe ejecutar** si algo requiere Neovim interactivo (`:MasonInstallAll`, `:TSUpdate`).
5. **Enlace** a `docs/notas-problemas-soluciones.md` si algo falló.

Ejemplo de cierre:

> Configuración montada. Abre un proyecto con `nvim .`, ejecuta `:Mason` si falta algún servidor, y usa `Espacio Espacio` para buscar archivos. Iconos requieren terminal con fuente **JetBrainsMono NFM** (reinicia la terminal).

---

## 7. Frase que el usuario dirá al agente

Copiar/pegar el usuario:

```text
Hice pull del repo neovim. Ejecuta todo lo que dice docs/notes/prompt-crear-todo-con-un-click.md: instala dependencias, verifica archivos, configura Windows Terminal y Cursor (fuente NFM), sincroniza Lazy/Mason/TSUpdate, y confirma el checklist final.
```

---

*Última actualización: configuración LazyVim + snacks + blink + LSP (vtsls) + treesitter + catppuccin, Windows, JetBrainsMono NFM, fd, rg.*
