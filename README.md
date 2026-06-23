# Neovim Config

## Información completa

https://wealthy-cosmonaut-a28.notion.site/SOFTWARE-ENVIROMENT-38377191e5fc80f8ba0add3a808f356d?source=copy_link

## Configuración de Neovim para Linux / Docker

Configuración de Neovim pensada para usarse dentro de un contenedor Linux o Docker.

## Orden de ramas

1. `linux-docker-2.0`, configuración base.
2. `linux-docker-2.2-lazygit`, configuración final con LazyGit.

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
apt install curl git -y
```

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

## Paso 3: cambiar a la rama con LazyGit

Si ya existe el repositorio en `/root/neovim`, no vuelvas a clonar. Cambia de rama:

```bash
cd /root/neovim

git fetch origin

git checkout linux-docker-2.2-lazygit

git pull

bash ./scripts/setup.sh
```

---

## Paso 4: abrir Neovim

Abrir Neovim con las variables correctas:

```bash
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
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

---

# Notas adicionales

Más información en:

```text
docs/notas-problemas-soluciones.md
```
