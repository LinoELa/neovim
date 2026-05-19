# Comandos y atajos

`<leader>` = **Espacio**

Copia para Notion: `docs/comandos-notion.md`

## Cursor (editor)

| Atajo | Acción |
|-------|--------|
| `Ctrl + /` | Abrir / cerrar terminal integrada |

## Autocompletado (blink.cmp)

Preset **super-tab** (estilo VS Code). Menú al escribir con LSP activo.

| Tecla | Acción |
|-------|--------|
| `Tab` | Siguiente / aceptar sugerencia |
| `Shift+Tab` | Anterior |
| `Ctrl+Space` | Abrir menú o documentación |
| `Ctrl+e` | Cerrar menú |

Ver `docs/blink-cmp.md`.

## Snacks

| Atajo           | Acción                    |
|-----------------|---------------------------|
| `Espacio e`     | Explorador de archivos    |
| `Espacio Espacio` | Buscar archivos (smart) |
| `Espacio ,`     | Buffers abiertos          |
| `Espacio /`     | Grep en el proyecto       |
| `Espacio :`     | Historial de comandos     |
| `Espacio n`     | Historial de notificaciones |

## LSP / Mason

| Atajo / comando | Acción                              |
|-----------------|-------------------------------------|
| `Espacio c l`   | Info LSP (recomendado)              |
| `:Mason`        | Instalar servidores LSP             |
| `:LspInfo`      | Alternativa (tras abrir un archivo) |

## LSP — atajos globales de Neovim (GLOBAL DEFAULTS)

Atajos que Neovim crea al arrancar (no dependen de LazyVim). Los podemos cambiar después en `keymaps.lua`.

| Atajo        | Modo              | Acción                          |
|--------------|-------------------|---------------------------------|
| `gra`        | Normal, Visual    | Acción de código (code action)  |
| `gri`        | Normal            | Ir a implementación             |
| `grn`        | Normal            | Renombrar símbolo               |
| `grr`        | Normal            | Referencias                     |
| `grt`        | Normal            | Ir a definición de tipo         |
| `grx`        | Normal            | Ejecutar code lens              |
| `gO`         | Normal            | Símbolos del documento          |
| `Ctrl+s`     | Insertar          | Ayuda de firma (signature help) |

### Por qué el cursor tiene que estar en el símbolo

El LSP no adivina qué quieres editar: actúa sobre **el símbolo bajo el cursor** (variable, función, tipo, etc.).

| Sin cursor en el símbolo | Con cursor en el símbolo |
|--------------------------|---------------------------|
| A menudo no pasa nada o da error | Renombra, busca referencias, va a definición, etc. |

Ejemplos: `grn` necesita saber **qué** renombrar; `grr` de **qué** buscar usos; `gra` en **qué** aplicar el arreglo. Igual que en VS Code: pon el cursor encima del nombre antes de usar la acción.

## Diagnósticos — atajos globales de Neovim (GLOBAL DEFAULTS)

Atajos para saltar entre errores y avisos del LSP en el buffer actual. Neovim los crea al arrancar.

| Atajo      | Acción                                              |
|------------|-----------------------------------------------------|
| `]d`       | Siguiente diagnóstico en el buffer                   |
| `[d`       | Diagnóstico anterior en el buffer                   |
| `]D`       | Último diagnóstico del buffer                       |
| `[D`       | Primer diagnóstico del buffer                       |
| `Ctrl+w d` | Mostrar el diagnóstico bajo el cursor en ventana flotante |
