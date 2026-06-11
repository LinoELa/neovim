# Neovim Config

Configuración personal de Neovim basada en `LazyVim`.

Está pensada principalmente para trabajar en:

1. Docker / Linux, mi entorno principal de pruebas y configuración.
2. Windows con WSL, mi segundo entorno más usado.
3. Windows nativo, útil si quiero usar Neovim directamente desde PowerShell.

Incluye:

- `LazyVim` como base.
- `lazy.nvim` para gestionar plugins.
- `snacks.nvim` para picker, explorer y búsquedas.
- `blink.cmp` para autocompletado con `Tab`.
- `Mason` + LSP para `lua`, `typescript/javascript`, `rust` y `python`.
- `nvim-treesitter` para parsers de sintaxis.
- `catppuccin` como tema base.
- Hooks locales de Git para automatizar tareas después de `git pull`.

---

## 1. Uso principal: Docker / Linux

Este es el flujo recomendado cuando estoy dentro de un contenedor Linux.

### 1.1 Primera instalación

Dentro del contenedor:

```bash
cd /root
git clone https://github.com/LinoELa/neovim.git
cd /root/neovim
bash ./scripts/setup.sh
```

El script debe encargarse de:

- instalar dependencias base;
- instalar `git`, `curl`, `ripgrep`, `fd`;
- instalar compilador C para Treesitter;
- instalar o corregir Neovim si la versión es antigua;
- sincronizar plugins con `Lazy`;
- configurar hooks locales de Git.

Al terminar, el propio script imprimirá el comando exacto para abrir Neovim.

Normalmente será algo parecido a:

```bash
cd /root/neovim
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Dentro de Neovim puedes ejecutar:

```vim
:Lazy
:Mason
:TSUpdate
:checkhealth
```

### 1.2 Si el repo ya existe

```bash
cd /root/neovim
git pull
bash ./scripts/setup.sh
```

### 1.3 Si no recuerdas dónde está el repo

Busca carpetas Git:

```bash
find / -type d -name ".git" 2>/dev/null
```

Si devuelve algo como:

```text
/root/neovim/.git
```

entra en la carpeta padre:

```bash
cd /root/neovim
git pull
bash ./scripts/setup.sh
```

### 1.4 Error típico: usar `git pull` fuera del repo

Esto está mal si todavía no has clonado el repo:

```bash
git pull https://github.com/LinoELa/neovim.git
```

Error esperado:

```text
fatal: not a git repository (or any of the parent directories): .git
```

Significa que estás fuera de una carpeta con `.git`.

Primero clona:

```bash
cd /root
git clone https://github.com/LinoELa/neovim.git
cd /root/neovim
bash ./scripts/setup.sh
```

### 1.5 Error típico: Neovim demasiado antiguo

Si ves algo como:

```text
lazy.nvim requires Neovim >= 0.8.0
```

significa que el sistema está usando un Neovim antiguo.

En Ubuntu puede pasar porque `apt install neovim` instala una versión vieja, por ejemplo `0.6.1`.

El `setup.sh` debe evitar esto instalando Neovim moderno desde `.tar.gz`, no desde AppImage.

No usar AppImage en Docker, porque suele fallar con:

```text
fuse: device not found
```

Comprobación manual:

```bash
which nvim
nvim --version
/usr/local/bin/nvim --version
```

La versión correcta debe ser `0.8.0` o superior.

Idealmente:

```text
NVIM v0.12.x
```

### 1.6 Error típico: `:Lazy` o `:Mason` no existen

Si dentro de Neovim aparece:

```text
E492: Not an editor command: Lazy
E492: Not an editor command: Mason
```

puede ser por una de estas causas:

1. Neovim es demasiado antiguo.
2. LazyVim no está cargando.
3. Estás abriendo otro `nvim`.
4. La configuración está en una ruta distinta.

Comandos útiles:

```bash
which nvim
nvim --version
echo $XDG_CONFIG_HOME
```

Dentro de Neovim:

```vim
:echo stdpath("config")
```

Para este repo, si está en `/root/neovim`, se usa así:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Así Neovim carga:

```text
/root/neovim/init.lua
```

---

## 2. Segundo entorno: Windows con WSL

Este flujo es recomendable si trabajo en Windows pero quiero un entorno Linux real.

### 2.1 Instalar dependencias dentro de WSL

En Ubuntu WSL:

```bash
sudo apt update
sudo apt install -y git curl ripgrep fd-find build-essential
```

Después clona la configuración:

```bash
cd ~
git clone https://github.com/LinoELa/neovim.git
cd ~/neovim
bash ./scripts/setup.sh
```

Abre Neovim:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=$HOME nvim
```

### 2.2 Usar la configuración como `~/.config/nvim`

Si quieres que `nvim` cargue esta config sin variables:

```bash
mkdir -p ~/.config
git clone https://github.com/LinoELa/neovim.git ~/.config/nvim
bash ~/.config/nvim/scripts/setup.sh
nvim
```

Si ya la tenías en `~/neovim`:

```bash
mkdir -p ~/.config
mv ~/neovim ~/.config/nvim
cd ~/.config/nvim
bash ./scripts/setup.sh
nvim
```

---

## 3. Windows nativo

Usa esto si quieres trabajar directamente desde PowerShell.

### 3.1 Instalación inicial

```powershell
git clone https://github.com/LinoELa/neovim.git $env:LOCALAPPDATA\nvim
cd $env:LOCALAPPDATA\nvim
.\scripts\setup.ps1
```

Después abre:

```powershell
nvim .
```

### 3.2 Dependencias manuales equivalentes

```powershell
winget install Git.Git
winget install Neovim.Neovim
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
winget install DEVCOM.JetBrainsMonoNerdFont
```

### 3.3 Ruta normal en Windows

```text
%LOCALAPPDATA%\nvim
```

Normalmente equivale a:

```text
C:\Users\TU_USUARIO\AppData\Local\nvim
```

---

## 4. Qué resuelve este repo

La idea es poder abrir un proyecto con:

```bash
nvim .
```

y tener listo:

- búsqueda de archivos con `<leader><space>`;
- búsqueda de texto con `<leader>/`;
- explorer con `<leader>e`;
- autocompletado con `Tab`;
- LSP con `gd`, `grr`, `grn`, `<leader>c l`;
- gestión de herramientas con `:Mason`;
- iconos correctos usando `JetBrainsMono NFM`.

---

## 5. Qué hace el setup

Los scripts de setup hacen esto:

1. Validan que estás en la raíz del repo correcto.
2. Comprueban dependencias base:
   - `git`;
   - `curl`;
   - `nvim`;
   - `fd`;
   - `rg`.
3. En Linux instalan compilador C para `nvim-treesitter`.
4. En Linux corrigen el caso `fd-find` / `fdfind`.
5. En Linux evitan Neovim antiguo instalando versión moderna si hace falta.
6. En Windows intentan instalar la fuente `JetBrainsMono NFM`.
7. Configuran:
   - `git config core.hooksPath .githooks`.
8. Ejecutan Neovim en modo headless:
   - `Lazy! sync`.
9. Al terminar imprimen el siguiente paso exacto para abrir Neovim.

---

## 6. Automatización después de `git pull`

Git no ejecuta hooks versionados por defecto.

Por eso el setup configura este repo para usar:

```text
.githooks/post-merge
```

Después del primer setup, un `git pull` que termine en merge puede lanzar el setup automáticamente.

Flujo recomendado:

```bash
git pull
bash ./scripts/setup.sh
```

En Windows:

```powershell
git pull
.\scripts\setup.ps1
```

Si el hook deja de funcionar:

```bash
git config --get core.hooksPath
```

Debe devolver:

```text
.githooks
```

Si no, vuelve a lanzar el setup.

---

## 7. Dependencias del sistema

### Linux / Docker

Necesarias:

- `git`
- `curl`
- `neovim`
- `ripgrep`
- `fd` o `fdfind`
- `gcc` / `cc` / `clang`
- `make`
- `tar`
- `gzip`

En Ubuntu / Debian:

```bash
sudo apt update
sudo apt install -y git curl ripgrep fd-find build-essential tar gzip
```

### Windows

Necesarias:

- Git
- Neovim
- fd
- ripgrep
- JetBrainsMono Nerd Font

Instalación por `winget`:

```powershell
winget install Git.Git
winget install Neovim.Neovim
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
winget install DEVCOM.JetBrainsMonoNerdFont
```

---

## 8. Fuente y terminal

Para que los iconos se vean bien:

- fuente: `JetBrainsMono NFM`;
- tamaño recomendado: `14`.

Si ves cuadrados, interrogaciones o iconos rotos:

1. instala la Nerd Font;
2. reinicia la terminal;
3. vuelve a abrir Neovim.

---

## 9. Atajos importantes

`<leader>` es `Espacio`.

| Atajo | Qué hace |
|---|---|
| `<leader><space>` | Buscar archivos |
| `<leader>/` | Buscar texto en el proyecto |
| `<leader>e` | Explorador |
| `<leader>,` | Buffers abiertos |
| `<leader>c l` | Info LSP |
| `gd` | Ir a definición |
| `grr` | Referencias |
| `grn` | Renombrar símbolo |
| `J` | Bajar 6 líneas |
| `K` | Subir 6 líneas |
| `Shift-h` | Buffer anterior |
| `Shift-l` | Buffer siguiente |
| `Tab` | Completar o siguiente sugerencia |

Guía completa:

```text
docs/commandos-vim.md
```

---

## 10. LSP y lenguajes configurados

Servidores configurados con `mason-lspconfig`:

| Servidor | Lenguaje |
|---|---|
| `lua_ls` | Lua |
| `vtsls` | TypeScript / JavaScript |
| `rust_analyzer` | Rust |
| `pyright` | Python |

Extra activo en `lazyvim.json`:

```text
lazyvim.plugins.extras.lang.typescript
```

---

## 11. Estructura del repo

```text
init.lua
lazyvim.json
lazy-lock.json
lua/
  config/
    lazy.lua
    options.lua
    keymaps.lua
    autocmds.lua
  plugins/
    snacks.lua
    blink.lua
    lsp.lua
    nvim-treesitter.lua
    catppuccin.lua
scripts/
  setup.ps1
  setup.sh
.githooks/
  post-merge
docs/
```

---

## 12. Plugins propios

| Plugin | Archivo | Documentación |
|---|---|---|
| `snacks.nvim` | `lua/plugins/snacks.lua` | `docs/snack.md` |
| `blink.cmp` | `lua/plugins/blink.lua` | `docs/blink-cmp.md` |
| `LSP + Mason` | `lua/plugins/lsp.lua` | `docs/LSP.md` |
| `treesitter` | `lua/plugins/nvim-treesitter.lua` | `docs/treesitter.md` |
| `catppuccin` | `lua/plugins/catppuccin.lua` | `docs/catppuccin.md` |

---

## 13. Documentación útil

| Archivo | Para qué sirve |
|---|---|
| `docs/README.md` | Índice general |
| `docs/commandos-vim.md` | Atajos del día a día |
| `docs/comandos-notion.md` | Guía larga para copiar a Notion |
| `docs/LSP.md` | LSP y servidores |
| `docs/mason.md` | Mason |
| `docs/treesitter.md` | Parsers |
| `docs/notas-problemas-soluciones.md` | Errores frecuentes |
| `docs/notes/prompt-crear-todo-con-un-click.md` | Checklist largo de instalación |

---

## 14. Problemas frecuentes

### `fd` o `rg` no funcionan

Comprueba:

```bash
fd --version
rg --version
```

En Ubuntu, si existe `fdfind` pero no `fd`:

```bash
mkdir -p ~/.local/bin
ln -sf "$(command -v fdfind)" ~/.local/bin/fd
export PATH="$HOME/.local/bin:$PATH"
```

### Treesitter falla al actualizar

Ejecuta:

```vim
:Lazy sync
:TSUpdate
```

Si sigue fallando, comprueba compilador C:

```bash
cc --version
gcc --version
make --version
```

En Ubuntu:

```bash
sudo apt install -y build-essential
```

### Mason no abre

Dentro de Neovim:

```vim
:Lazy
```

Si `:Lazy` tampoco existe, la config no está cargando o Neovim es antiguo.

Comprueba:

```bash
nvim --version
```

Debe ser `0.8.0` o superior.

### El hook no salta tras `git pull`

Comprueba:

```bash
git config --get core.hooksPath
```

Debe devolver:

```text
.githooks
```

Si no:

```bash
git config core.hooksPath .githooks
```

---

## 15. Reglas para mantener esta config

1. No añadir `lua/plugins/example.lua`.
2. No importar plugins en `init.lua`.
3. `init.lua` solo debe cargar:
   ```lua
   require("config.lazy")
   ```
4. Plugins nuevos en:
   ```text
   lua/plugins/<nombre>.lua
   ```
5. Documentación nueva en:
   ```text
   docs/
   ```
6. Tras cambios de plugins o tooling:
   ```vim
   :Lazy sync
   ```

---

## 16. Estado esperado al terminar

Una instalación sana debe cumplir:

```bash
nvim --version
fd --version
rg --version
```

Dentro de Neovim:

```vim
:Lazy
:Mason
:checkhealth
```

Atajos que deben funcionar:

- `<leader><space>`;
- `<leader>/`;
- `<leader>e`.

Si algo falla, empieza por:

```text
docs/notas-problemas-soluciones.md
```
