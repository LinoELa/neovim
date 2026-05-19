# Prompt para configurar Neovim con un click

## Link del prompt

- Archivo: [prompt-crear-todo-con-un-click.md](C:/Users/psalvador/AppData/Local/nvim/docs/notes/prompt-crear-todo-con-un-click.md:1)
- Ruta relativa: `docs/notes/prompt-crear-todo-con-un-click.md`

## Informacion del prompt

- Contexto del repo, rutas de Windows y stack configurado: `LazyVim`, `Snacks`, `Blink`, `LSP` y `Treesitter`.
- Checklist final de lo que debe funcionar al terminar.
- Fase A: instalar con `winget` `Neovim`, `fd`, `rg` y `JetBrainsMono Nerd Font`.
- Fase B: revisar `clone` o `pull`, validar archivos obligatorios y eliminar archivos que sobran como `example.lua`.
- Fase C: configurar Windows Terminal y Cursor con fuente `JetBrainsMono NFM` y tamano `14`.
- Fase D: ejecutar `:Lazy sync`, `:MasonInstallAll` y `:TSUpdate`.
- Fase E: hacer verificaciones y `healthchecks`.
- Reglas para no romper configuraciones de `LSP`, `blink` y plugins.
- Frase final lista para pegar al agente.

## Como usarlo

- Ejecuta:

```powershell
cd $env:LOCALAPPDATA\nvim
git pull
```

- Luego pega en Cursor:

```text
Hice pull del repo neovim. Ejecuta todo lo que dice docs/notes/prompt-crear-todo-con-un-click.md: instala dependencias, verifica archivos, configura Windows Terminal y Cursor (fuente NFM), sincroniza Lazy/Mason/TSUpdate, y confirma el checklist final.
```

## Nota

- Los archivos del repo van en el `pull`.
- El prompt cubre lo externo: `winget`, Windows Terminal, Cursor y pasos dentro de Neovim.
