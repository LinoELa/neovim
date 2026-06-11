# Neovim Config

Configuracion personal de Neovim basada en `LazyVim`, preparada para Windows y Linux.

Incluye:

- `snacks.nvim` para picker, explorer y busquedas
- `blink.cmp` para autocompletado con `Tab`
- `Mason` + LSP para `lua`, `ts/js`, `rust` y `python`
- `nvim-treesitter` para parsers de sintaxis
- `catppuccin` como tema base
- automatizacion de post-`git pull` con hook local `post-merge`

## Que resuelve este repo

La idea es que puedas hacer esto:

```powershell
cd C:\ruta\de\tu\proyecto
nvim .
```

Y tener listo:

- busqueda de archivos con `<leader><space>`
- grep con `<leader>/`
- explorer con `<leader>e`
- autocompletado con `Tab`
- LSP con `gd`, `grr`, `grn`, `<leader>c l`, `:Mason`
- iconos correctos usando `JetBrainsMono NFM`

## Inicio rapido

### Windows

Primera vez o despues de clonar:

```powershell
git pull
.\scripts\setup.ps1
```

### Linux

Primera vez o despues de clonar:

```bash
git pull
bash ./scripts/setup.sh
```

### Docker

1. #### Error normal si haces `git pull` fuera del repo

Si entras al contenedor y ejecutas esto:


```bash
mkdir -p ~/.config
git clone https://github.com/LinoELa/neovim.git ~/.config/nvim
nvim
```

Es lo mismo que arriba 

```bash
git pull https://github.com/LinoELa/neovim.git
```

La respuesta normal es:

```text
fatal: not a git repository (or any of the parent directories): .git
```

Eso significa que todavia no estas dentro de una carpeta clonada con `.git`.

2. #### Primera instalacion dentro del contenedor

Ejecuta esto paso a paso:

```bash
cd /root
git clone https://github.com/LinoELa/neovim.git
cd neovim
bash ./scripts/setup.sh
```

Respuesta esperada:

- `Cloning into 'neovim'...`
- instalacion de dependencias si faltan
- sincronizacion de `Lazy`
- al final, el script te dira que abras Neovim con un comando exacto

3. #### Si el repo ya estaba clonado

Ejecuta esto:

```bash
cd /root/neovim
git pull
bash ./scripts/setup.sh
```

Respuesta esperada:

- `Already up to date.` o descarga de cambios nuevos
- despues, salida del script de setup

4. #### Si no recuerdas donde estaba el repo

Busca la carpeta Git:

```bash
find / -type d -name ".git" 2>/dev/null
```

Posible respuesta:

```text
/root/neovim/.git
```

Si sale una ruta como esa, entra a la carpeta padre:

```bash
cd /root/neovim
git pull
bash ./scripts/setup.sh
```

5. #### Que hacer cuando termine `setup.sh`

El propio script imprimira en consola algo como esto:

```bash
cd /root/neovim
NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
```

Ejecuta ese comando.

Dentro de Neovim, ejecuta:

```vim
:Mason
:TSUpdate
```

Respuesta esperada:

- `:Mason` abre el gestor de herramientas LSP
- `:TSUpdate` instala o actualiza parsers de Treesitter

6. #### Notas importantes

- el setup headless usa `NVIM_APPNAME` con el nombre real de la carpeta
- `cd /root/neovim` funciona
- `cd ~/.config/nvim` tambien funciona
- si renombras la carpeta, el setup cargara esa config con ese nombre

## Que hace el setup

Los scripts de `setup` hacen lo siguiente:

1. Validan que estas en la raiz del repo correcto.
2. Comprueban dependencias base:
   - `git`
   - `nvim`
   - `fd`
   - `rg`
3. En Linux instalan tambien el compilador C necesario para `nvim-treesitter`.
4. En Windows intentan instalar tambien la fuente `JetBrainsMono NFM`.
5. Configuran `git config core.hooksPath .githooks`.
6. Ejecutan Neovim en modo headless para correr:
   - `Lazy! sync`
7. Al terminar, imprimen en consola el siguiente paso exacto para abrir Neovim y rematar:
   - `NVIM_APPNAME=<nombre-del-repo> XDG_CONFIG_HOME=<carpeta-padre> nvim`
   - `:Mason`
   - `:TSUpdate`

## Automatizacion tras git pull

Git no ejecuta hooks versionados por si solo. Por eso el primer setup configura este repo para usar:

```text
.githooks/post-merge
```

Desde ese momento, cada `git pull` que termine en merge vuelve a lanzar el setup automaticamente.

Flujo recomendado:

```powershell
git pull
.\scripts\setup.ps1
```

Luego, en pulls futuros:

```powershell
git pull
```

Si en algun momento deja de funcionar el hook, ejecuta otra vez:

```powershell
.\scripts\setup.ps1
```

## Dependencias del sistema

### Windows

Instalacion manual equivalente:

```powershell
winget install Git.Git
winget install Neovim.Neovim
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
winget install DEVCOM.JetBrainsMonoNerdFont
```

### Linux

El script detecta `apt`, `dnf`, `pacman` o `zypper`. Si no encuentra un gestor soportado, tendras que instalar manualmente:

- `git`
- `neovim`
- `fd` o `fdfind`
- `ripgrep`

### Docker vs maquina real

Este repo es una configuracion de Neovim. Puedes usarlo en dos contextos distintos:

1. Dentro de un contenedor Linux, si quieres que Neovim viva ahi.
2. En tu sistema real, que es lo normal si vas a editar desde tu propia terminal o editor.

Rutas habituales:

- Linux real: `~/.config/nvim`
- Windows real: `%LOCALAPPDATA%\nvim`
- Docker de pruebas: por ejemplo `/root/neovim` o `/root/.config/nvim`

Si solo lo has clonado en `/root/neovim`, eso no instala automaticamente la config global de Neovim dentro del contenedor. Para usarla como config real dentro de Linux, lo correcto suele ser:

```bash
mkdir -p ~/.config
git clone https://github.com/LinoELa/neovim.git ~/.config/nvim
bash ~/.config/nvim/scripts/setup.sh
```

Si ya lo clonaste en `/root/neovim` y quieres reutilizarlo como config real:

```bash
mkdir -p ~/.config
mv /root/neovim ~/.config/nvim
cd ~/.config/nvim
bash ./scripts/setup.sh
```

Si ejecutaste `bash ./scripts/setup.sh` desde `/root/neovim` y te salio algo como esto:

```text
E492: Not an editor command: Lazy! sync
E492: Not an editor command: MasonInstallAll
E492: Not an editor command: TSUpdateSync
```

el problema era que Neovim no estaba cargando esta config al arrancar en headless. El setup actual ya fuerza la ruta correcta usando `NVIM_APPNAME` + `XDG_CONFIG_HOME`.

## Fuente y terminal

Para que los iconos se vean bien:

- fuente terminal: `JetBrainsMono NFM`
- tamano recomendado: `14`
- opcion en Neovim: `vim.opt.guifont = "JetBrainsMono NFM:h14"`

Si ves cuadrados, interrogaciones o iconos rotos:

1. instala la Nerd Font
2. reinicia la terminal
3. vuelve a abrir Neovim

## Primer arranque manual

Si prefieres hacerlo sin script:

```powershell
cd ruta\al\repo
nvim .
```

Luego dentro de Neovim:

```vim
:Lazy sync
:MasonInstallAll
:TSUpdate
```

## Atajos importantes

`<leader>` es `Espacio`.

| Atajo | Que hace |
|-------|----------|
| `<leader><space>` | Buscar archivos |
| `<leader>/` | Buscar texto en el proyecto |
| `<leader>e` | Explorador |
| `<leader>,` | Buffers abiertos |
| `<leader>c l` | Info LSP |
| `gd` | Ir a definicion |
| `grr` | Referencias |
| `grn` | Renombrar simbolo |
| `J` | Bajar 6 lineas |
| `K` | Subir 6 lineas |
| `Shift-h` | Buffer anterior |
| `Shift-l` | Buffer siguiente |
| `Tab` | Completar o siguiente sugerencia |

Guia completa: [docs/commandos-vim.md](docs/commandos-vim.md)

## LSP y lenguajes configurados

Actualmente esta config asegura estos servidores via `mason-lspconfig`:

| Servidor | Lenguaje |
|----------|----------|
| `lua_ls` | Lua |
| `vtsls` | TypeScript / JavaScript |
| `rust_analyzer` | Rust |
| `pyright` | Python |

Extras activos en `lazyvim.json`:

- `lazyvim.plugins.extras.lang.typescript`

## Estructura del repo

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

## Plugins propios

| Plugin | Archivo | Doc |
|--------|---------|-----|
| `snacks.nvim` | `lua/plugins/snacks.lua` | [docs/snack.md](docs/snack.md) |
| `blink.cmp` | `lua/plugins/blink.lua` | [docs/blink-cmp.md](docs/blink-cmp.md) |
| `LSP + Mason` | `lua/plugins/lsp.lua` | [docs/LSP.md](docs/LSP.md) |
| `treesitter` | `lua/plugins/nvim-treesitter.lua` | [docs/treesitter.md](docs/treesitter.md) |
| `catppuccin` | `lua/plugins/catppuccin.lua` | [docs/catppuccin.md](docs/catppuccin.md) |

## Documentacion util

| Archivo | Para que sirve |
|---------|----------------|
| [docs/README.md](docs/README.md) | indice general |
| [docs/commandos-vim.md](docs/commandos-vim.md) | atajos del dia a dia |
| [docs/comandos-notion.md](docs/comandos-notion.md) | guia larga para copiar a Notion |
| [docs/LSP.md](docs/LSP.md) | LSP y servidores |
| [docs/mason.md](docs/mason.md) | Mason |
| [docs/treesitter.md](docs/treesitter.md) | parsers |
| [docs/notas-problemas-soluciones.md](docs/notas-problemas-soluciones.md) | errores frecuentes |
| [docs/notes/prompt-crear-todo-con-un-click.md](docs/notes/prompt-crear-todo-con-un-click.md) | checklist largo de instalacion |

## Problemas frecuentes

### `fd` o `rg` no funcionan

- instala la herramienta que falte
- cierra y abre la terminal
- vuelve a ejecutar el setup

### Los iconos se ven mal

- revisa que la terminal use `JetBrainsMono NFM`
- reinicia la terminal despues de instalar la fuente

### Treesitter falla al actualizar

Prueba:

```vim
:Lazy sync
:TSUpdate
```

Si persiste, mira [docs/notas-problemas-soluciones.md](docs/notas-problemas-soluciones.md).

### El hook no salta tras `git pull`

Comprueba:

```powershell
git config --get core.hooksPath
```

Debe devolver:

```text
.githooks
```

Si no, vuelve a lanzar:

```powershell
.\scripts\setup.ps1
```

## Reglas para mantener esta config

1. No anadir `lua/plugins/example.lua`.
2. No importar plugins en `init.lua`; ahi solo debe vivir `require("config.lazy")`.
3. Plugins nuevos: `lua/plugins/<nombre>.lua`.
4. Documentacion nueva: en `docs/`, no en `lua/plugins/`.
5. Tras cambios de plugins o tooling: `:Lazy sync`.

## Estado esperado al terminar

Al final de una instalacion sana deberias poder confirmar:

- `nvim --version`
- `fd --version`
- `rg --version`
- `:Lazy`
- `:Mason`
- `<leader><space>`
- `<leader>/`
- `<leader>e`

Si alguno falla, empieza por [docs/notas-problemas-soluciones.md](docs/notas-problemas-soluciones.md).
