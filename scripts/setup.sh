#!/usr/bin/env bash
set -euo pipefail

# ==============================================================================
# Setup seguro para configuración Neovim / LazyVim
# ==============================================================================
#
# Objetivo:
#   Preparar una máquina Linux o un contenedor Docker para usar esta configuración
#   de Neovim sin volver a caer en el error:
#
#     lazy.nvim requires Neovim >= 0.8.0
#
# Qué hace:
#   1. Valida que el repo tenga la estructura esperada.
#   2. Configura hooks locales de Git si existe .githooks.
#   3. Instala dependencias base: git, curl, tar, gzip, ripgrep, fd.
#   4. Instala compilador C y herramientas de build para Treesitter y LSP.
#   5. Corrige el caso de Ubuntu, donde fd se instala como fdfind.
#   6. Configura locale UTF-8 si está vacío o mal definido.
#   7. Comprueba la versión real de Neovim.
#   8. Si Neovim es antiguo, instala Neovim moderno desde tar.gz.
#   9. Sincroniza plugins con lazy.nvim.
#   10. Instala herramientas base de Mason para LSP, formatters y linters.
#   11. Instala tree-sitter-cli para nvim-treesitter.
#
# Uso:
#   ./scripts/setup.sh
#
# Uso desde hook post-merge:
#   ./scripts/setup.sh --post-merge
#
# Nota:
#   No se usa AppImage porque en muchos contenedores Docker falla por FUSE.
# ==============================================================================

MIN_NVIM_VERSION="0.8.0"
POST_MERGE=0

if [[ "${1:-}" == "--post-merge" ]]; then
  POST_MERGE=1
fi

# ------------------------------------------------------------------------------
# Funciones de salida
# ------------------------------------------------------------------------------

step() {
  printf '\n==> %s\n' "$1"
}

info() {
  printf '  %s\n' "$1"
}

warn() {
  printf 'WARNING: %s\n' "$1" >&2
}

fail() {
  printf '\nERROR: %s\n' "$1" >&2
  exit 1
}

# ------------------------------------------------------------------------------
# Funciones base
# ------------------------------------------------------------------------------

have() {
  command -v "$1" >/dev/null 2>&1
}

use_sudo() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  elif have sudo; then
    sudo "$@"
  else
    fail "Necesito privilegios para instalar paquetes y no hay sudo."
  fi
}

detect_package_manager() {
  if have apt-get; then
    echo "apt"
    return
  fi

  if have dnf; then
    echo "dnf"
    return
  fi

  if have pacman; then
    echo "pacman"
    return
  fi

  if have zypper; then
    echo "zypper"
    return
  fi

  echo "unknown"
}

install_packages() {
  local packages=("$@")
  local manager

  manager="$(detect_package_manager)"

  case "$manager" in
    apt)
      use_sudo apt-get update
      use_sudo env DEBIAN_FRONTEND=noninteractive apt-get install -y "${packages[@]}"
      ;;
    dnf)
      use_sudo dnf install -y "${packages[@]}"
      ;;
    pacman)
      use_sudo pacman -Sy --noconfirm "${packages[@]}"
      ;;
    zypper)
      use_sudo zypper install -y "${packages[@]}"
      ;;
    *)
      fail "No reconozco el gestor de paquetes. Instala manualmente: ${packages[*]}"
      ;;
  esac
}

ensure_command() {
  local command_name="$1"
  shift

  local packages=("$@")

  if have "$command_name"; then
    info "$command_name ya está disponible."
    return
  fi

  step "Instalando $command_name"
  install_packages "${packages[@]}"

  if [[ "$command_name" == "fd" ]]; then
    ensure_fd_alias
  fi

  if ! have "$command_name"; then
    fail "No encuentro '$command_name' tras instalar: ${packages[*]}"
  fi
}

# ------------------------------------------------------------------------------
# Rutas del repositorio
# ------------------------------------------------------------------------------

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"

cd "$REPO_ROOT"

REPO_NAME="$(basename "$REPO_ROOT")"
CONFIG_HOME="$(dirname "$REPO_ROOT")"

# Ejemplo:
#   REPO_ROOT=/root/neovim
#   REPO_NAME=neovim
#   CONFIG_HOME=/root
#
# Con esto:
#   NVIM_APPNAME=neovim XDG_CONFIG_HOME=/root nvim
#
# Neovim carga:
#   /root/neovim/init.lua

# ------------------------------------------------------------------------------
# Validación del repositorio
# ------------------------------------------------------------------------------

assert_repo_shape() {
  local required=(
    "init.lua"
    "lua/config/lazy.lua"
    "lua/plugins/lsp.lua"
    "lua/plugins/nvim-treesitter.lua"
  )

  for path in "${required[@]}"; do
    if [[ ! -e "$path" ]]; then
      fail "Falta '$path'. Ejecuta este script desde la raíz del repositorio o revisa la estructura."
    fi
  done
}

# ------------------------------------------------------------------------------
# Locale UTF-8
# ------------------------------------------------------------------------------

ensure_utf8_locale() {
  step "Comprobando locale UTF-8"

  if [[ "${LANG:-}" == *"UTF-8"* || "${LANG:-}" == *"utf8"* || "${LC_ALL:-}" == *"UTF-8"* || "${LC_ALL:-}" == *"utf8"* || "${LC_CTYPE:-}" == *"UTF-8"* || "${LC_CTYPE:-}" == *"utf8"* ]]; then
    info "Locale UTF-8 ya configurado: LANG=${LANG:-}, LC_ALL=${LC_ALL:-}, LC_CTYPE=${LC_CTYPE:-}"
    return
  fi

  warn "Locale UTF-8 no está configurado. Intentando corregirlo."

  if have apt-get; then
    install_packages locales
    use_sudo locale-gen en_US.UTF-8 || true
  fi

  local selected_locale=""

  if locale -a 2>/dev/null | grep -qi '^en_US\.utf8$'; then
    selected_locale="en_US.UTF-8"
  elif locale -a 2>/dev/null | grep -qi '^C\.utf8$'; then
    selected_locale="C.UTF-8"
  else
    selected_locale="en_US.UTF-8"
  fi

  export LANG="$selected_locale"
  export LC_ALL="$selected_locale"

  if [[ -f "$HOME/.bashrc" ]]; then
    grep -q '^export LANG=' "$HOME/.bashrc" || echo "export LANG=$selected_locale" >> "$HOME/.bashrc"
    grep -q '^export LC_ALL=' "$HOME/.bashrc" || echo "export LC_ALL=$selected_locale" >> "$HOME/.bashrc"
  fi

  info "Locale configurado: LANG=$LANG, LC_ALL=$LC_ALL"
}

# ------------------------------------------------------------------------------
# Git hooks
# ------------------------------------------------------------------------------

configure_git_hooks() {
  step "Configurando hooks locales de Git"

  if [[ -d ".githooks" ]]; then
    git config core.hooksPath .githooks
    info "Hooks configurados en .githooks."
  else
    info "No existe .githooks. Se omite esta parte."
  fi
}

# ------------------------------------------------------------------------------
# fd en Ubuntu
# ------------------------------------------------------------------------------

ensure_fd_alias() {
  # En Ubuntu/Debian el paquete fd-find instala el binario como fdfind.
  # LazyVim y Telescope suelen esperar el comando fd.
  # Por eso creamos:
  #
  #   ~/.local/bin/fd -> /usr/bin/fdfind

  if have fd; then
    return
  fi

  if have fdfind; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    export PATH="$HOME/.local/bin:$PATH"

    if [[ -f "$HOME/.bashrc" ]]; then
      grep -q 'export PATH="$HOME/.local/bin:$PATH"' "$HOME/.bashrc" || \
        echo 'export PATH="$HOME/.local/bin:$PATH"' >> "$HOME/.bashrc"
    fi

    info "Creado alias real: fd -> fdfind."
  fi
}

# ------------------------------------------------------------------------------
# Toolchain para Treesitter, LSP y builds
# ------------------------------------------------------------------------------

ensure_build_toolchain() {
  step "Comprobando compilador C y herramientas de build"

  if have cc || have gcc || have clang; then
    info "Compilador C ya disponible."
  else
    case "$(detect_package_manager)" in
      apt)
        install_packages build-essential
        ;;
      dnf)
        install_packages gcc gcc-c++ make
        ;;
      pacman)
        install_packages base-devel
        ;;
      zypper)
        install_packages gcc gcc-c++ make
        ;;
      *)
        fail "No pude instalar un compilador C. Instala gcc, clang y make manualmente."
        ;;
    esac
  fi

  # make también es importante para algunos parsers y herramientas.
  if ! have make; then
    case "$(detect_package_manager)" in
      apt)
        install_packages make
        ;;
      dnf)
        install_packages make
        ;;
      pacman)
        install_packages make
        ;;
      zypper)
        install_packages make
        ;;
      *)
        warn "No encuentro make. Puede fallar Treesitter."
        ;;
    esac
  fi
}

# ------------------------------------------------------------------------------
# Neovim moderno
# ------------------------------------------------------------------------------

nvim_bin() {
  if have nvim; then
    command -v nvim
  else
    echo ""
  fi
}

nvim_version() {
  local bin="$1"

  "$bin" --version | head -n 1 | sed -E 's/^NVIM v//'
}

version_ge() {
  # Devuelve correcto si $1 >= $2.
  #
  # Ejemplo:
  #   version_ge "0.12.3" "0.8.0"

  printf '%s\n%s\n' "$2" "$1" | sort -V -C
}

install_modern_neovim_tarball() {
  step "Instalando Neovim moderno desde tar.gz"

  # No usamos AppImage:
  #   En Docker suele fallar con:
  #   fuse: device not found
  #
  # La release tar.gz evita ese problema.

  ensure_command curl curl
  ensure_command tar tar
  ensure_command gzip gzip

  use_sudo rm -f /usr/local/bin/nvim
  use_sudo rm -rf /opt/nvim-linux-x86_64 /opt/nvim

  curl -L \
    https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz \
    -o /tmp/nvim-linux-x86_64.tar.gz

  use_sudo tar -C /opt -xzf /tmp/nvim-linux-x86_64.tar.gz
  use_sudo ln -sf /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

  # Bash puede tener cacheado /usr/bin/nvim.
  # hash -r fuerza a recalcular la ruta.
  hash -r || true

  if ! /usr/local/bin/nvim --version >/dev/null 2>&1; then
    fail "La instalación moderna de Neovim falló."
  fi

  info "Neovim moderno instalado en /usr/local/bin/nvim."
}

ensure_neovim_version() {
  step "Comprobando Neovim"

  if ! have nvim; then
    install_packages neovim
  fi

  local current_bin
  current_bin="$(nvim_bin)"

  if [[ -z "$current_bin" ]]; then
    fail "No encuentro nvim."
  fi

  local current_version
  current_version="$(nvim_version "$current_bin")"

  info "Binario detectado: $current_bin"
  info "Versión detectada: NVIM v$current_version"

  if version_ge "$current_version" "$MIN_NVIM_VERSION"; then
    info "Neovim es compatible con lazy.nvim."
    return
  fi

  warn "Neovim es demasiado antiguo. lazy.nvim necesita Neovim >= $MIN_NVIM_VERSION."
  install_modern_neovim_tarball

  local new_version
  new_version="$(/usr/local/bin/nvim --version | head -n 1 | sed -E 's/^NVIM v//')"

  info "Nueva versión detectada: NVIM v$new_version"

  if ! version_ge "$new_version" "$MIN_NVIM_VERSION"; then
    fail "Neovim sigue siendo demasiado antiguo tras instalar la versión moderna."
  fi

  # Asegura que esta sesión use el nuevo nvim.
  export PATH="/usr/local/bin:$PATH"
  hash -r || true
}

resolved_nvim() {
  # Siempre priorizamos /usr/local/bin/nvim porque ahí instalamos la versión moderna.
  if [[ -x "/usr/local/bin/nvim" ]]; then
    echo "/usr/local/bin/nvim"
    return
  fi

  command -v nvim
}

# ------------------------------------------------------------------------------
# Dependencias generales para LazyVim
# ------------------------------------------------------------------------------

ensure_base_dependencies() {
  step "Comprobando dependencias base"

  ensure_command git git
  ensure_command curl curl
  ensure_command unzip unzip
  ensure_command rg ripgrep

  if have apt-get; then
    ensure_command fd fd-find
  else
    ensure_command fd fd
  fi

  ensure_fd_alias
  ensure_build_toolchain
}

# ------------------------------------------------------------------------------
# Sincronización de plugins
# ------------------------------------------------------------------------------

run_nvim_sync() {
  step "Sincronizando plugins y herramientas de Neovim"

  local nvim_cmd
  nvim_cmd="$(resolved_nvim)"

  info "Usando Neovim: $nvim_cmd"

  NVIM_APPNAME="$REPO_NAME" \
  XDG_CONFIG_HOME="$CONFIG_HOME" \
  "$nvim_cmd" --headless "+Lazy! sync" "+qa"
}

# ------------------------------------------------------------------------------
# Herramientas base de Mason
# ------------------------------------------------------------------------------

ensure_mason_tools() {
  step "Instalando herramientas base de Mason"

  local nvim_cmd
  nvim_cmd="$(resolved_nvim)"

  local mason_tools=(
    tree-sitter-cli
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
  )

  info "Usando Neovim: $nvim_cmd"
  info "Herramientas Mason: ${mason_tools[*]}"

  local mason_script
  mason_script="$(mktemp)"

  cat > "$mason_script" <<'EOF'
local tools = {
  "tree-sitter-cli",
  "lua-language-server",
  "stylua",
  "typescript-language-server",
  "eslint-lsp",
  "prettierd",
  "prettier",
  "json-lsp",
  "yaml-language-server",
  "dockerls",
  "docker-compose-language-service",
  "bash-language-server",
  "shellcheck",
  "shfmt",
  "pyright",
}

local ok_mason, mason = pcall(require, "mason")
if not ok_mason then
  vim.api.nvim_err_writeln("No se pudo cargar mason.nvim.")
  vim.cmd("cquit")
end

mason.setup()

local ok_registry, registry = pcall(require, "mason-registry")
if not ok_registry then
  vim.api.nvim_err_writeln("No se pudo cargar mason-registry. Revisa que mason.nvim esté instalado.")
  vim.cmd("cquit")
end

local function install_tools()
  local failed = {}

  for _, name in ipairs(tools) do
    local ok_pkg, pkg = pcall(registry.get_package, name)

    if not ok_pkg then
      table.insert(failed, name .. " (no existe en Mason registry)")
    elseif not pkg:is_installed() then
      print("Instalando " .. name)
      pkg:install()
    else
      print(name .. " ya instalado")
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
    vim.api.nvim_err_writeln("Fallaron herramientas Mason: " .. table.concat(failed, ", "))
    vim.cmd("cquit")
  end

  print("Mason terminado correctamente.")
  vim.cmd("qa")
end

registry.refresh(install_tools)
EOF

  NVIM_APPNAME="$REPO_NAME" \
  XDG_CONFIG_HOME="$CONFIG_HOME" \
  "$nvim_cmd" --headless \
    "+lua require('lazy').load({ plugins = { 'mason.nvim' } })" \
    -l "$mason_script"

  rm -f "$mason_script"
}

# ------------------------------------------------------------------------------
# Reporte final
# ------------------------------------------------------------------------------

print_versions() {
  step "Versiones detectadas"

  git --version || true

  local nvim_cmd
  nvim_cmd="$(resolved_nvim)"
  "$nvim_cmd" --version | head -n 1 || true

  fd --version || true
  rg --version | head -n 1 || true

  if have cc; then
    cc --version | head -n 1 || true
  elif have gcc; then
    gcc --version | head -n 1 || true
  elif have clang; then
    clang --version | head -n 1 || true
  fi
}

print_next_steps() {
  local nvim_cmd
  nvim_cmd="$(resolved_nvim)"

  printf '\nListo. Ahora ejecuta esto en consola:\n'
  printf '  cd %q\n' "$REPO_ROOT"
  printf '  NVIM_APPNAME=%q XDG_CONFIG_HOME=%q %q\n' "$REPO_NAME" "$CONFIG_HOME" "$nvim_cmd"

  printf '\nDentro de Neovim puedes ejecutar:\n'
  printf '  :Lazy\n'
  printf '  :Mason\n'
  printf '  :TSUpdate\n'
  printf '  :checkhealth\n'
  printf '\nHerramientas Mason instaladas automáticamente por el setup:\n'
  printf '  tree-sitter-cli, dockerls, docker-compose-language-service, yaml-language-server, json-lsp\n'
  printf '  typescript-language-server, eslint-lsp, prettier, prettierd\n'
  printf '  bash-language-server, shellcheck, shfmt, lua-language-server, stylua, pyright\n'
}

# ------------------------------------------------------------------------------
# Ejecución principal
# ------------------------------------------------------------------------------

step "Validando repositorio"
assert_repo_shape

ensure_utf8_locale
ensure_base_dependencies
configure_git_hooks
ensure_neovim_version
run_nvim_sync
ensure_mason_tools

if [[ "$POST_MERGE" -eq 1 ]]; then
  printf '\nHook post-merge ejecutado correctamente.\n'
  print_next_steps
  exit 0
fi

print_versions
print_next_steps
