# LSP - MASON

```
MASON → herramienta para instalar y gestionar servidores de lenguaje (LSP), linters, formatters, etc. de forma sencilla.
LSP (Language Server Protocol) → protocolo que permite a los editores de código comunicarse con servidores de lenguaje para funciones como autocompletado, diagnóstico de errores, etc.
```



Vamos a instalar y configurar los LSP principales para **TypeScript** y **JavaScript**, ya que son los lenguajes que más usamos en el trabajo.

Los servidores principales serán:

```txt
ts_ls
```

Para TypeScript y JavaScript.

También conviene instalar estos porque suelen aparecer en proyectos frontend:

```txt
html
cssls
jsonls
eslint
```

Quedaría así:

```lua
ensure_installed = {
  "ts_ls",
  "html",
  "cssls",
  "jsonls",
  "eslint",
}
```

Resumen:

```txt
ts_ls   → TypeScript y JavaScript
html    → HTML
cssls   → CSS
jsonls  → JSON
eslint  → reglas y errores de ESLint
```
