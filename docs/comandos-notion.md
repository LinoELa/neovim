# Neovim + Cursor — Guía de comandos

> Copiar esta página a Notion.  
> Repo: https://github.com/LinoELa/neovim  
> `<leader>` = tecla **Espacio**

---

## 1. Cursor (fuera de Neovim)

| Atajo | Qué hace |
|-------|----------|
| `Ctrl + /` | Abrir / cerrar **terminal integrada** |

---

## 2. Regla de oro en Neovim

| Concepto | Detalle |
|----------|---------|
| `<leader>` | Tecla **Espacio** en esta config |
| Modo Normal | Para atajos con letras (`gra`, `gd`, `Espacio e`) |
| Modo Insertar | Para `Ctrl+s`, `Tab`, autocompletado |
| Cursor en símbolo | En LSP (`grn`, `grr`, `gra`…) el cursor debe estar **encima** del nombre |

---

## 3. Snacks — los que usamos cada día

| Atajo | Qué hace |
|-------|----------|
| `Espacio` + `Espacio` | Buscar archivos (smart: buffers + recientes + proyecto) |
| `Espacio` + `e` | Explorador de archivos |
| `Espacio` + `,` | Buffers abiertos |
| `Espacio` + `/` | Buscar texto en el proyecto (grep) |
| `Espacio` + `:` | Historial de comandos |
| `Espacio` + `n` | Historial de notificaciones |

---

## 4. Autocompletado (blink.cmp)

| Atajo | Qué hace |
|-------|----------|
| `Tab` | Siguiente sugerencia / aceptar |
| `Shift` + `Tab` | Sugerencia anterior |
| `Ctrl` + `Espacio` | Abrir menú o documentación |
| `Ctrl` + `e` | Cerrar menú de autocompletado |

---

## 5. LSP y Mason

| Atajo / comando | Qué hace |
|-----------------|----------|
| `Espacio` + `c` + `l` | Info LSP (**el que mejor funciona**) |
| `:Mason` | Abrir Mason — instalar servidores |
| `:MasonInstallAll` | Instalar todo lo configurado |
| `:MasonInstall <nombre>` | Instalar un servidor (ej. `vtsls`) |
| `:LspInfo` | Estado LSP (a veces tras abrir un archivo) |
| `:checkhealth vim.lsp` | Diagnóstico LSP |

### Dentro de `:Mason`

| Tecla | Qué hace |
|-------|----------|
| `i` | Instalar paquete seleccionado |
| `X` | Desinstalar |
| `U` | Actualizar |
| `q` | Salir |

### Servidores que usamos

| Servidor | Para qué |
|----------|----------|
| `vtsls` | TypeScript, JavaScript, TSX |
| `lua_ls` | Lua (config Neovim) |
| `rust_analyzer` | Rust |
| `pyright` | Python |

---

## 6. LSP — atajos globales Neovim (`gr…`)

Creados por Neovim al arrancar. **Normal mode.**

| Atajo | Qué hace |
|-------|----------|
| `g` + `r` + `a` | Acción de código (fix rápido, etc.) |
| `g` + `r` + `i` | Ir a implementación |
| `g` + `r` + `n` | Renombrar símbolo |
| `g` + `r` + `r` | Referencias |
| `g` + `r` + `t` | Ir a definición de **tipo** |
| `g` + `r` + `x` | Ejecutar code lens |
| `g` + `O` | Símbolos del documento |
| `Ctrl` + `s` | Ayuda de firma *(modo Insertar)* |

---

## 7. LSP — atajos LazyVim útiles (`g` + letra)

| Atajo | Qué hace |
|-------|----------|
| `g` + `d` | Ir a definición |
| `g` + `r` | Referencias |
| `g` + `D` | Ir a declaración |
| `g` + `I` | Ir a implementación |
| `g` + `y` | Ir a definición de tipo |
| `K` | Hover (documentación flotante) |
| `Espacio` + `c` + `a` | Acción de código |
| `Espacio` + `c` + `r` | Renombrar |
| `Espacio` + `c` + `d` | Diagnóstico en línea (flotante) |

---

## 8. Diagnósticos — saltar entre errores

| Atajo | Qué hace |
|-------|----------|
| `]` + `d` | Siguiente error/aviso en el archivo |
| `[` + `d` | Error/aviso anterior |
| `]` + `D` | Último diagnóstico del buffer |
| `[` + `D` | Primer diagnóstico del buffer |
| `Ctrl` + `w` + `d` | Ver diagnóstico bajo el cursor (ventana flotante) |

---

## 9. Comandos Neovim (escribir con `:`)

| Comando | Qué hace |
|---------|----------|
| `:Lazy` | Gestor de plugins |
| `:Lazy sync` | Sincronizar / instalar plugins |
| `:Mason` | Gestor de LSP y herramientas |
| `:MasonInstallAll` | Instalar servidores configurados |
| `:TSUpdate` | Actualizar parsers treesitter |
| `:TSInstall <lang>` | Instalar un parser |
| `:checkhealth` | Estado general |
| `:checkhealth lazy` | Estado lazy.nvim |
| `:checkhealth mason` | Estado Mason |
| `:checkhealth nvim-treesitter` | Estado treesitter |
| `:q` | Salir |
| `:wq` | Guardar y salir |
| `:qa` | Salir de todo |

---

## 10. LazyVim — otros atajos útiles

| Atajo | Qué hace |
|-------|----------|
| `Espacio` + `l` | Abrir `:Lazy` |
| `Espacio` + `f` + `n` | Archivo nuevo |
| `Espacio` + `b` + `d` | Cerrar buffer |
| `Espacio` + `u` + `f` | Formato automático on/off |
| `Espacio` + `u` + `d` | Diagnósticos on/off |
| `Espacio` + `q` + `q` | Salir de Neovim (todo) |

*(LazyVim tiene muchos más con `Espacio` + …; escribe `Espacio` y espera el menú which-key.)*

---

## 11. Terminal (Windows / Cursor)

| Atajo | Qué hace |
|-------|----------|
| `Ctrl` + `/` | Terminal en **Cursor** |
| `Ctrl` + `0` | Restablecer zoom de fuente en terminal |
| `Ctrl` + `c` | Copiar (Windows Terminal) |
| `Ctrl` + `v` | Pegar (Windows Terminal) |

**Fuente necesaria para iconos en Neovim:** `JetBrainsMono NFM` (Nerd Font), tamaño **14**.

---

## 12. PowerShell — instalar dependencias

```powershell
winget install sharkdp.fd
winget install BurntSushi.ripgrep.MSVC
winget install DEVCOM.JetBrainsMonoNerdFont
winget install Neovim.Neovim
```

Comprobar:

```powershell
fd --version
rg --version
nvim --version
```

---

## 13. Arrancar un proyecto

```powershell
cd C:\ruta\al\proyecto
nvim .
```

Primera vez o tras pull:

```vim
:Lazy sync
:MasonInstallAll
:TSUpdate
```

---

## 14. Mapa mental rápido

| Quiero… | Usar… |
|---------|--------|
| Buscar archivo | `Espacio Espacio` |
| Buscar texto | `Espacio /` |
| Explorador | `Espacio e` |
| Terminal en Cursor | `Ctrl /` |
| Autocompletar | `Tab` |
| Ir a definición | `gd` |
| Renombrar | `grn` o `Espacio c r` |
| Ver error siguiente | `]d` |
| Instalar LSP | `:Mason` |
| Info LSP | `Espacio c l` |

---

## 15. Enlaces

| Recurso | Dónde |
|---------|--------|
| Repo config | https://github.com/LinoELa/neovim |
| Problemas frecuentes | `docs/notas-problemas-soluciones.md` |
| Montar todo tras pull | `docs/notes/prompt-crear-todo-con-un-click.md` |
