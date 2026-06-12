# Neovim Config para Linux y Docker

Configuración personal de Neovim basada en `LazyVim`, enfocada a entornos Linux y contenedores Docker.

Rama principal usada actualmente:

```text
linux-docker-2.0
```

Repositorio:

```text
https://github.com/LinoELa/neovim/tree/linux-docker-2.0
```

---

## 1. Objetivo

Este repo sirve para preparar Neovim como entorno de trabajo listo para desarrollo.

Está pensado principalmente para:

1. Contenedores Docker con Linux.
2. Máquinas Linux reales.
3. WSL usando Linux, aunque esta guía se centra en Linux/Docker.

Incluye:

- `LazyVim` como base.
- `lazy.nvim` como gestor de plugins.
- `snacks.nvim` para picker, explorer y búsquedas.
- `blink.cmp` para autocompletado.
- `Mason` para instalar LSP, linters y formatters.
- `nvim-treesitter` para resaltado y parsers.
- `catppuccin` como tema.
- `setup.sh` para automatizar dependencias y configuración.

---

## 2. Instalación rápida en Docker

Este bloque es el recomendado cuando creas un contenedor nuevo y quieres dejar Neovim funcionando rápido.

```bash
apt update
apt install curl git -y

cd /root
git clone --single-branch -b linux-docker-2.0 https://github.com/LinoELa/neovim.git
cd /root/neovim

bash ./scripts/setup.sh

NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Dentro de Neovim comprueba:

```vim
:Lazy
:Mason
:TSUpdate
:checkhealth
```

Si esos comandos funcionan, la configuración está cargando correctamente.

---

## 3. Dónde clonar el repo en Docker

Cuando entras en un contenedor nuevo, normalmente estás en:

```bash
/
```

Puedes comprobarlo con:

```bash
pwd
```

Si ves carpetas como estas:

```text
bin  boot  dev  etc  home  lib  media  mnt  opt  proc  root  run  sbin  srv  sys  tmp  usr  var
```

estás en la raíz del sistema.

No clones el repositorio directamente en `/`, porque ahí viven carpetas internas de Linux.

La ruta recomendada dentro de Docker es:

```text
/root/neovim
```

Motivo:

- `/root` es el home del usuario root dentro del contenedor.
- `/root/neovim` queda separado del sistema.
- Es fácil de encontrar y mantener.
- Funciona bien con `NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root`.

---

## 4. Instalación paso a paso en Docker

### 4.1 Instalar Git y Curl

En Ubuntu o Debian dentro del contenedor:

```bash
apt update
apt install curl git -y
```

Esto instala lo mínimo para poder descargar el repo y ejecutar el setup.

`git` sirve para clonar el repositorio.

`curl` sirve para descargar dependencias, por ejemplo una versión moderna de Neovim si hace falta.

---

### 4.2 Entrar en `/root`

```bash
cd /root
```

Comprueba:

```bash
pwd
```

Debe salir:

```text
/root
```

---

### 4.3 Clonar la rama correcta

La rama usada actualmente es:

```text
linux-docker-2.0
```

Clona solo esa rama:

```bash
git clone --single-branch -b linux-docker-2.0 https://github.com/LinoELa/neovim.git
```

Esto crea:

```text
/root/neovim
```

Entra en el repo:

```bash
cd /root/neovim
```

Comprueba la rama:

```bash
git branch
```

Resultado esperado:

```text
* linux-docker-2.0
```

---

### 4.4 Ejecutar el setup

```bash
bash ./scripts/setup.sh
```

El script se encarga de:

- validar que estás en el repo correcto;
- instalar dependencias base;
- instalar `git`, `curl`, `ripgrep`, `fd`, `tar` y `gzip`;
- instalar compilador C y `make`;
- corregir `fd-find` en Ubuntu;
- configurar locale UTF-8;
- comprobar la versión real de Neovim;
- instalar Neovim moderno si el del sistema es antiguo;
- evitar AppImage en Docker;
- sincronizar plugins con `Lazy`;
- instalar herramientas base de Mason;
- configurar hooks locales de Git.

---

### 4.5 Abrir Neovim

Después del setup, abre Neovim así:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Ese comando hace que Neovim cargue esta configuración:

```text
/root/neovim/init.lua
```

Dentro de Neovim ejecuta:

```vim
:Lazy
:Mason
:TSUpdate
:checkhealth
```

---

## 5. Instalación en Linux real

En una máquina Linux real tienes dos opciones.

---

### 5.1 Opción recomendada: usar `~/.config/nvim`

Esta opción permite abrir Neovim simplemente con:

```bash
nvim
```

Instalación:

```bash
mkdir -p ~/.config
git clone --single-branch -b linux-docker-2.0 https://github.com/LinoELa/neovim.git ~/.config/nvim
bash ~/.config/nvim/scripts/setup.sh
nvim
```

Esta es la forma más limpia para un Linux real.

---

### 5.2 Opción alternativa: usar `~/neovim`

Esta opción mantiene el repo separado y lo cargas con variables de entorno.

```bash
cd ~
git clone --single-branch -b linux-docker-2.0 https://github.com/LinoELa/neovim.git
cd ~/neovim
bash ./scripts/setup.sh

NVIM_APPNAME=neovim XDG_CONFIG_HOME=$HOME nvim
```

---

## 6. Actualizar el repo

Si el repo ya existe:

```bash
cd /root/neovim
git pull
bash ./scripts/setup.sh
```

En Linux real con `~/.config/nvim`:

```bash
cd ~/.config/nvim
git pull
bash ./scripts/setup.sh
```

Después abre Neovim:

```bash
nvim
```

o, si estás usando `/root/neovim` dentro de Docker:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

---

## 7. Si no recuerdas dónde está el repo

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

Si aparece:

```text
/root/.config/nvim/.git
```

entra aquí:

```bash
cd /root/.config/nvim
git branch
git pull
bash ./scripts/setup.sh
```

---

## 8. Qué hace el setup

El archivo principal es:

```text
scripts/setup.sh
```

Hace estas tareas:

1. Valida la estructura del repo.
2. Configura locale UTF-8.
3. Instala dependencias base.
4. Configura hooks locales de Git.
5. Comprueba la versión de Neovim.
6. Instala Neovim moderno si hace falta.
7. Ejecuta `Lazy! sync`.
8. Instala herramientas de Mason.
9. Muestra versiones detectadas.
10. Muestra el comando final para abrir Neovim.

---

## 9. Herramientas instaladas por Mason

El setup instala herramientas base para los lenguajes que más se usan en este entorno.

```text
lua-language-server
stylua
typescript-language-server
eslint-lsp
prettierd
prettier
json-lsp
yaml-language-server
dockerls
docker-compose-language-service
bash-language-server
shellcheck
shfmt
pyright
```

Esto cubre:

| Uso | Herramienta |
|---|---|
| Lua | `lua-language-server`, `stylua` |
| JavaScript / TypeScript | `typescript-language-server`, `eslint-lsp` |
| Formato JS / TS / JSON / YAML | `prettier`, `prettierd` |
| JSON | `json-lsp` |
| YAML | `yaml-language-server` |
| Dockerfile | `dockerls` |
| Docker Compose | `docker-compose-language-service` |
| Bash | `bash-language-server`, `shellcheck`, `shfmt` |
| Python | `pyright` |

---

## 10. Dependencias del sistema

En Ubuntu / Debian:

```bash
apt update
apt install -y git curl ripgrep fd-find build-essential tar gzip
```

El setup también puede instalar lo necesario automáticamente.

Dependencias importantes:

- `git`
- `curl`
- `neovim`
- `ripgrep`
- `fd` o `fdfind`
- `gcc`, `cc` o `clang`
- `make`
- `tar`
- `gzip`

---

## 11. Neovim antiguo

Si ves este error:

```text
lazy.nvim requires Neovim >= 0.8.0
```

significa que el sistema está usando un Neovim demasiado antiguo.

En Ubuntu puede pasar porque:

```bash
apt install neovim
```

puede instalar una versión vieja, por ejemplo:

```text
NVIM v0.6.1
```

El setup evita esto instalando Neovim moderno desde `.tar.gz`.

No se usa AppImage en Docker porque suele fallar con:

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

Si `/usr/local/bin/nvim --version` muestra una versión moderna pero `nvim --version` sigue mostrando una antigua:

```bash
hash -r
nvim --version
```

---

## 12. `:Lazy` o `:Mason` no existen

Si aparece:

```text
E492: Not an editor command: Lazy
E492: Not an editor command: Mason
```

puede ser por:

1. Neovim es antiguo.
2. LazyVim no está cargando.
3. Estás abriendo otro `nvim`.
4. La config está en otra ruta.
5. No estás usando bien `NVIM_APPNAME` y `XDG_CONFIG_HOME`.

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

Para Docker con repo en `/root/neovim`:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

---

## 13. Error típico: hacer `git pull` fuera del repo

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
git clone --single-branch -b linux-docker-2.0 https://github.com/LinoELa/neovim.git
cd /root/neovim
bash ./scripts/setup.sh
```

Después, cuando ya estés dentro de `/root/neovim`, puedes usar:

```bash
git pull
```

---

## 14. Automatización después de `git pull`

Git no ejecuta hooks versionados por defecto.

Por eso el setup configura este repo para usar:

```text
.githooks/post-merge
```

Después del primer setup, un `git pull` que termine en merge puede lanzar el setup automáticamente.

Comprueba el hook:

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

## 15. Atajos importantes

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
  setup.sh
.githooks/
  post-merge
docs/
```

---

## 17. Problemas frecuentes

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

### Treesitter falla

Ejecuta:

```vim
:Lazy sync
:TSUpdate
```

Comprueba compilador C:

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

Comprueba:

```vim
:Lazy
```

Si `:Lazy` tampoco existe:

```bash
nvim --version
```

Debe ser `0.8.0` o superior.

---

## 18. Reglas para mantener esta config

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

## 19. Estado esperado al terminar

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

Si algo falla, revisa:

```text
docs/notas-problemas-soluciones.md
```
