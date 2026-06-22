# Neovim Config

Configuración personal de Neovim basada en `LazyVim`.

Rama principal usada actualmente:

```text
develop-linux-docker
```

Repositorio:

```text
https://github.com/LinoELa/neovim/tree/develop-linux-docker
```

Esta configuración está pensada principalmente para trabajar en:

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

## Uso e instalación en Docker / Linux

### Uso de ramas Linux / Docker

La idea de esta estructura es separar cada cambio grande en su propia rama y usar `develop-linux-docker` como rama integradora.

Orden recomendado:

1. Primero prueba `linux-docker-2.0`, que es la base estable para Linux / Docker.
2. Si eso funciona bien, prueba `linux-docker-2.1`, que aÃ±ade la parte de Mason.
3. Si eso tambiÃ©n funciona bien, prueba `linux-docker-2.2-lazygit`, que aÃ±ade solo la auto-instalaciÃ³n de `lazygit`.
4. Cuando quieras usar todo junto, usa `develop-linux-docker`, que es la rama que integra Linux / Docker completo.

Resumen de ramas:

- `prod`: base estable.
- `linux-docker-2.0`: base Linux / Docker.
- `linux-docker-2.1`: capa de Mason.
- `linux-docker-2.2-lazygit`: capa de auto-instalaciÃ³n de `lazygit`.
- `develop-linux-docker`: integraciÃ³n de todo lo anterior para Linux / Docker.

Nomenclatura prevista:

- `develop-linux-docker` queda reservado ahora para Linux / Docker.
- Si mÃ¡s adelante se separa el flujo de Windows, la rama equivalente serÃ¡ `develop-windows`.

---

### Configuracion Rapida Docker - Linux 

#### Hay que leer mas abajo es Importante

```bash
apt update
apt install curl git -y

cd /root
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git
cd /root/neovim

bash ./scripts/setup.sh

NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim

```

Este es el flujo principal cuando se crea un contenedor nuevo.

Normalmente al entrar en el contenedor estás en la raíz del sistema:

```bash
/
```

Puedes comprobarlo con:

```bash
pwd
```

Si ves algo como esto:

```text
bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

significa que estás en `/`.

No clones el repositorio directamente en `/`, porque `/` es la raíz del sistema y contiene carpetas internas de Linux.

La ruta recomendada para este repo dentro de Docker es:

```text
/root/neovim
```

---

### 1.1 Instalar Git y Curl

Primero instala `git` y `curl`.

En Ubuntu / Debian dentro del contenedor:

```bash
apt update
apt install curl git -y
```

Esto es necesario porque:

- `git` sirve para clonar el repositorio;
- `curl` sirve para descargar dependencias, como una versión moderna de Neovim si hace falta.

---

### 1.2 Ir a `/root`

Después entra en `/root`:

```bash
cd /root
```

Comprueba la ruta:

```bash
pwd
```

Debe salir:

```text
/root
```

---

### 1.3 Clonar la rama correcta

La rama usada actualmente es:

```text
develop-linux-docker
```

Clona esa rama concreta:

```bash
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git
```

Esto crea la carpeta:

```text
/root/neovim
```

Entra en el repositorio:

```bash
cd /root/neovim
```

Comprueba la rama:

```bash
git branch
```

Debe aparecer:

```text
* develop-linux-docker
```

---

### 1.4 Ejecutar el setup

Ejecuta:

```bash
bash ./scripts/setup.sh
```

El script debe encargarse de:

- instalar dependencias base;
- instalar `git`, `curl`, `ripgrep`, `fd`;
- instalar compilador C para Treesitter;
- instalar `make`;
- instalar o corregir Neovim si la versión es antigua;
- evitar AppImage en Docker;
- sincronizar plugins con `Lazy`;
- configurar hooks locales de Git.

Al terminar, el propio script imprimirá el comando exacto para abrir Neovim.

Normalmente será algo parecido a:

```bash
cd /root/neovim
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

---

### 1.5 Abrir Neovim

Abre Neovim con:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Dentro de Neovim prueba:

```vim
:Lazy
:Mason
:TSUpdate
:checkhealth
```

Si `:Lazy` y `:Mason` funcionan, la configuración está cargando bien.

---

### 1.6 Flujo completo desde cero

Este es el bloque completo para copiar y pegar en un contenedor nuevo:

```bash
apt update
apt install curl git -y

cd /root
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git
cd /root/neovim

bash ./scripts/setup.sh

NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Dentro de Neovim:

```vim
:Lazy
:Mason
:TSUpdate
:checkhealth
```

---

## 2. Actualizar el repo en Docker / Linux

Si el repo ya existe:

```bash
cd /root/neovim
git pull
bash ./scripts/setup.sh
```

Después abre Neovim:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

---

## 3. Si no recuerdas dónde está el repo

Busca carpetas Git:

```bash
find / -type d -name ".git" 2>/dev/null
```

Si aparece:

```text
/root/neovim/.git
```

entra en la carpeta padre:

```bash
cd /root/neovim
git branch
git pull
bash ./scripts/setup.sh
```

---

## 4. Error típico: hacer `git pull` fuera del repo

Esto está mal si todavía no has clonado el repo:

```bash
git pull https://github.com/LinoELa/neovim.git
```

Error esperado:

```text
fatal: not a git repository (or any of the parent directories): .git
```

Significa que estás fuera de una carpeta Git.

Primero clona:

```bash
cd /root
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git
cd /root/neovim
bash ./scripts/setup.sh
```

Después, cuando ya estés dentro de `/root/neovim`, sí puedes usar:

```bash
git pull
```

---

## 5. Error típico: Neovim demasiado antiguo

Si ves:

```text
lazy.nvim requires Neovim >= 0.8.0
```

significa que el sistema está usando un Neovim antiguo.

En Ubuntu puede pasar porque:

```bash
apt install neovim
```

puede instalar una versión antigua, por ejemplo:

```text
NVIM v0.6.1
```

LazyVim necesita una versión moderna.

El `setup.sh` debe evitar esto instalando Neovim moderno desde `.tar.gz`.

No usar AppImage en Docker, porque suele fallar con:

```text
fuse: device not found
```

Comprobaciones útiles:

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

Si `/usr/local/bin/nvim --version` muestra una versión moderna pero `nvim --version` muestra una antigua, limpia la caché de Bash:

```bash
hash -r
nvim --version
```

---

## 6. Error típico: `:Lazy` o `:Mason` no existen

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
5. No estás usando `NVIM_APPNAME` y `XDG_CONFIG_HOME` correctamente.

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

Para este repo, si está en `/root/neovim`, se abre así:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Así Neovim carga:

```text
/root/neovim/init.lua
```

---

## 7. Segundo entorno: Windows con WSL

Este flujo es recomendable si trabajo en Windows pero quiero un entorno Linux real.

### 7.1 Instalar dependencias dentro de WSL

En Ubuntu WSL:

```bash
sudo apt update
sudo apt install -y git curl ripgrep fd-find build-essential tar gzip
```

Después clona la rama correcta:

```bash
cd ~
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git
cd ~/neovim
bash ./scripts/setup.sh
```

Abre Neovim:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=$HOME nvim
```

---

### 7.2 Usar la configuración como `~/.config/nvim`

Si quieres que `nvim` cargue esta config sin variables:

```bash
mkdir -p ~/.config
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git ~/.config/nvim
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

## 8. Windows nativo

Usa esto si quieres trabajar directamente desde PowerShell.

### 8.1 Instalación inicial

```powershell
git clone --single-branch -b develop-linux-docker https://github.com/LinoELa/neovim.git $env:LOCALAPPDATA\nvim
cd $env:LOCALAPPDATA\nvim
.\scripts\setup.ps1
```

Después abre:

```powershell
nvim .
```

---

### 8.2 Dependencias manuales equivalentes

```powershell
winget install Git.Git
winget install Neovim.Neovim
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
winget install DEVCOM.JetBrainsMonoNerdFont
```

---

### 8.3 Ruta normal en Windows

```text
%LOCALAPPDATA%\nvim
```

Normalmente equivale a:

```text
C:\Users\TU_USUARIO\AppData\Local\nvim
```

---

## 9. Qué resuelve este repo

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

## 10. Qué hace el setup

Los scripts de setup hacen esto:

1. Validan que estás en la raíz del repo correcto.
2. Comprueban dependencias base:
   - `git`;
   - `curl`;
   - `nvim`;
   - `fd`;
   - `rg`.
3. En Linux instalan compilador C para `nvim-treesitter`.
4. En Linux instalan `make`, `tar` y `gzip` si hacen falta.
5. En Linux corrigen el caso `fd-find` / `fdfind`.
6. En Linux evitan Neovim antiguo instalando versión moderna si hace falta.
7. En Windows intentan instalar la fuente `JetBrainsMono NFM`.
8. Configuran:
   - `git config core.hooksPath .githooks`.
9. Ejecutan Neovim en modo headless:
   - `Lazy! sync`.
10. Al terminar imprimen el siguiente paso exacto para abrir Neovim.

---

## 11. Automatización después de `git pull`

Git no ejecuta hooks versionados por defecto.

Por eso el setup configura este repo para usar:

```text
.githooks/post-merge
```

Después del primer setup, un `git pull` que termine en merge puede lanzar el setup automáticamente.

Flujo recomendado en Linux / Docker:

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

Si no:

```bash
git config core.hooksPath .githooks
```

---

## 12. Dependencias del sistema

### 12.1 Linux / Docker

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
apt update
apt install -y git curl ripgrep fd-find build-essential tar gzip
```

### 12.2 Windows

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

## 13. Fuente y terminal

Para que los iconos se vean bien:

- fuente: `JetBrainsMono NFM`;
- tamaño recomendado: `14`.

Si ves cuadrados, interrogaciones o iconos rotos:

1. instala la Nerd Font;
2. reinicia la terminal;
3. vuelve a abrir Neovim.

---

## 14. Atajos importantes

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

## 15. LSP y lenguajes configurados

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

## 16. Estructura del repo

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

## 17. Plugins propios

| Plugin | Archivo | Documentación |
|---|---|---|
| `snacks.nvim` | `lua/plugins/snacks.lua` | `docs/snack.md` |
| `blink.cmp` | `lua/plugins/blink.lua` | `docs/blink-cmp.md` |
| `LSP + Mason` | `lua/plugins/lsp.lua` | `docs/LSP.md` |
| `treesitter` | `lua/plugins/nvim-treesitter.lua` | `docs/treesitter.md` |
| `catppuccin` | `lua/plugins/catppuccin.lua` | `docs/catppuccin.md` |

---

## 18. Documentación útil

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

## 19. Problemas frecuentes

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
apt install -y build-essential
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

## 20. Reglas para mantener esta config

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

## 21. Estado esperado al terminar

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
