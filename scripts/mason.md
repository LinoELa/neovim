#!/usr/bin/env bash
set -euo pipefail

NVIM_APPNAME="${NVIM_APPNAME:-neovim}"
XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-/root}"
NVIM_BIN="${NVIM_BIN:-/usr/local/bin/nvim}"

if ! command -v unzip >/dev/null 2>&1; then
  echo "ERROR: falta unzip. Ejecuta: apt install unzip -y"
  exit 1
fi

if ! command -v "$NVIM_BIN" >/dev/null 2>&1 && [[ ! -x "$NVIM_BIN" ]]; then
  echo "ERROR: no encuentro Neovim en $NVIM_BIN"
  exit 1
fi

MASON_SCRIPT="$(mktemp)"

cat > "$MASON_SCRIPT" <<'EOF'
local tools = {
  -- LSP de la imagen
  "lua-language-server",
  "pyright",
  "rust-analyzer",
  "typescript-language-server",
  "vtsls",

  -- Formatters
  "stylua",
  "prettier",
  "prettierd",

  -- Web / frontend
  "html-lsp",
  "css-lsp",
  "json-lsp",
  "yaml-language-server",

  -- Bash / Docker
  "bash-language-server",
  "shellcheck",
  "shfmt",
  "dockerls",
  "docker-compose-language-service",

  -- Treesitter CLI
  "tree-sitter-cli",
}

local ok_mason, mason = pcall(require, "mason")
if ok_mason then
  mason.setup()
end

local ok_registry, registry = pcall(require, "mason-registry")
if not ok_registry then
  vim.api.nvim_err_writeln("No se pudo cargar mason-registry.")
  vim.cmd("cquit")
end

registry.refresh(function()
  local failed = {}

  for _, name in ipairs(tools) do
    local ok_pkg, pkg = pcall(registry.get_package, name)

    if not ok_pkg then
      print("NO EXISTE EN MASON: " .. name)
      table.insert(failed, name)
    elseif pkg:is_installed() then
      print("YA INSTALADO: " .. name)
    else
      print("INSTALANDO: " .. name)
      pkg:install()
    end
  end

  local completed = vim.wait(600000, function()
    for _, name in ipairs(tools) do
      local ok_pkg, pkg = pcall(registry.get_package, name)
      if ok_pkg and pkg:is_installing() then
        return false
      end
    end
    return true
  end, 1000)

  if not completed then
    vim.api.nvim_err_writeln("Timeout instalando herramientas Mason.")
    vim.cmd("cquit")
  end

  for _, name in ipairs(tools) do
    local ok_pkg, pkg = pcall(registry.get_package, name)
    if ok_pkg and not pkg:is_installed() then
      table.insert(failed, name)
    end
  end

  if #failed > 0 then
    vim.api.nvim_err_writeln("Fallaron: " .. table.concat(failed, ", "))
    vim.cmd("cquit")
  end

  print("Mason terminado correctamente.")
  vim.cmd("qa")
end)
EOF

NVIM_APPNAME="$NVIM_APPNAME" \
XDG_CONFIG_HOME="$XDG_CONFIG_HOME" \
"$NVIM_BIN" --headless \
  "+Lazy load mason.nvim" \
  -l "$MASON_SCRIPT"

rm -f "$MASON_SCRIPT"