# Neovim Config

## Información completa

https://wealthy-cosmonaut-a28.notion.site/SOFTWARE-ENVIROMENT-38377191e5fc80f8ba0add3a808f356d?source=copy_link

## Configuración de Neovim para Linux / Docker

Configuración de Neovim pensada para usarse dentro de un contenedor Linux o Docker.

## Orden de ramas

1. `linux-docker-2.0` — configuración base
2. `linux-docker-2.1-mason` — Mason automático en `setup.sh`
3. `linux-docker-2.2-lazygit` — configuración final con LazyGit (destino)

Rama recomendada actual:

```text
linux-docker-2.2-lazygit
```

---

# Instalación dentro del contenedor

## Paso 1: instalar dependencias básicas

Dentro del contenedor:

```bash
apt update
apt install curl git unzip -y
```

`unzip` lo necesita Mason para descomprimir binarios. Si no lo instalas aquí, `setup.sh` intentará instalarlo en sistemas con `apt-get`.

---

## Paso 2: clonar configuración base

Clonar primero la rama base:

```bash
cd /root

git clone --single-branch -b linux-docker-2.0 https://github.com/LinoELa/neovim.git

cd /root/neovim

bash ./scripts/setup.sh
```

Importante: clonar en `/root/neovim`, no en `/`.

---

## Paso 3: cambiar a la rama Mason

Si el repo ya existe en `/root/neovim`, no vuelvas a clonar:

```bash
cd /root/neovim
git fetch origin
git checkout linux-docker-2.1-mason
git pull
bash ./scripts/setup.sh
```

En esta rama, `setup.sh` instala automáticamente herramientas de Mason (LSP, linters y formatters):

| Uso | Herramientas |
|-----|--------------|
| Lua | `lua-language-server`, `stylua` |
| JavaScript / TypeScript | `typescript-language-server`, `eslint-lsp`, `prettier`, `prettierd` |
| JSON / YAML | `json-lsp`, `yaml-language-server` |
| Docker | `dockerls`, `docker-compose-language-service` |
| Bash | `bash-language-server`, `shellcheck`, `shfmt` |
| Python | `pyright` |
| Treesitter | `tree-sitter-cli` |

Al terminar deberías ver en consola: `Mason terminado correctamente.`

---

## Paso 4: cambiar a la rama con LazyGit

Si ya existe el repositorio en `/root/neovim`, no vuelvas a clonar. Cambia de rama:

```bash
cd /root/neovim

git fetch origin

git checkout linux-docker-2.2-lazygit

git pull

bash ./scripts/setup.sh
```

---

## Paso 5: abrir Neovim

Tu configuración debe abrirse así:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim .
```

Para no escribir eso cada vez, crea un alias (funciona desde cualquier directorio):

```bash
echo 'alias nvim="NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root /usr/local/bin/nvim"' >> ~/.bashrc
source ~/.bashrc
```

Ahora puedes usar:

```bash
nvim .
```

Comprueba que el alias existe:

```bash
type nvim
```

Debe salir algo como:

```text
nvim is aliased to ...
```

---

# Mason setup (opcional)

- En `linux-docker-2.0`, Mason **no** se instala en el `setup.sh` base.
- En `linux-docker-2.1-mason` (y ramas posteriores), `setup.sh` **ya instala** las herramientas de Mason de forma automática.
- Usa `mason-setup.sh` solo si quieres **reinstalar o actualizar** herramientas Mason sin repetir todo el setup.

Comprueba que existe:

```bash
ls -l ./scripts/mason-setup.sh
```

Comprueba que tienes unzip:

```bash
command -v unzip
```

Ejecutar:

```bash
cd /root/neovim
chmod +x ./scripts/mason-setup.sh
bash ./scripts/mason-setup.sh
```

O si ya tiene permisos de ejecución:

```bash
./scripts/mason-setup.sh
```

---

# Actualizar la rama actual

Antes de actualizar, comprueba en qué rama estás:

```bash
cd /root/neovim

git branch -vv
```

Actualizar:

```bash
git pull

bash ./scripts/setup.sh

nvim .
```

Si no creaste el alias del Paso 5, usa:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Tras el primer `setup.sh`, un `git pull` puede lanzar el setup automáticamente mediante `.githooks/post-merge`.

Si no ocurre, ejecuta manualmente:

```bash
bash ./scripts/setup.sh
```

---

# Comprobar que Neovim carga bien

Dentro de Neovim, ejecuta:

```vim
:Lazy
:Mason
:TSUpdate
:checkhealth
```

---

# Errores frecuentes

## `git pull` fuera del repositorio

Error:

```text
fatal: not a git repository (or any of the parent directories): .git
```

Solución:

```bash
cd /root/neovim
```

Si el repositorio no existe, vuelve al paso de clonado.

---

## Neovim demasiado antiguo

Error:

```text
lazy.nvim requires Neovim >= 0.8.0
```

El script `setup.sh` instala una versión moderna de Neovim desde `.tar.gz`.

No uses AppImage dentro de Docker, porque puede dar este error:

```text
fuse: device not found
```

Comprobar versión:

```bash
hash -r

nvim --version
```

Debe ser `0.8.0` o superior.

---

## `:Lazy` o `:Mason` no existen

Probablemente has abierto Neovim sin las variables correctas.

Ábrelo así:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

O con el alias del Paso 5:

```bash
nvim .
```

---

## Mason no instala herramientas

**Síntomas:** el setup termina pero `:Mason` está vacío, o ves errores de timeout / `unzip`.

**Comprueba:**

```bash
command -v unzip
cd /root/neovim
git branch --show-current
bash ./scripts/setup.sh
```

En `linux-docker-2.1-mason` o posterior, Mason se instala con `setup.sh`. En `linux-docker-2.0` debes pasar al Paso 3 antes.

**Reinstalar solo Mason:**

```bash
cd /root/neovim
bash ./scripts/mason-setup.sh
```

Dentro de Neovim:

```vim
:Mason
:checkhealth mason
```

---

# Notas adicionales

Más información en:

```text
docs/notas-problemas-soluciones.md
docs/mason.md
LINUX-DOCKER.md
```
