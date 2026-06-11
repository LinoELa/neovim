#!/usr/bin/env bash
set -euo pipefail

post_merge=0
if [[ "${1:-}" == "--post-merge" ]]; then
  post_merge=1
fi

step() {
  printf '\n==> %s\n' "$1"
}

have() {
  command -v "$1" >/dev/null 2>&1
}

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$repo_root"
repo_name="$(basename "$repo_root")"
config_home="$(dirname "$repo_root")"

assert_repo_shape() {
  local required=(
    "init.lua"
    "lua/config/lazy.lua"
    "lua/plugins/lsp.lua"
    "lua/plugins/nvim-treesitter.lua"
  )

  for path in "${required[@]}"; do
    [[ -e "$path" ]] || {
      echo "Falta '$path'. Ejecuta este script desde la raiz del repo." >&2
      exit 1
    }
  done
}

configure_git_hooks() {
  step "Configurando hooks locales de Git"
  git config core.hooksPath .githooks
}

use_sudo() {
  if [[ "${EUID:-$(id -u)}" -eq 0 ]]; then
    "$@"
  elif have sudo; then
    sudo "$@"
  else
    echo "Necesito privilegios para instalar paquetes y no hay sudo." >&2
    exit 1
  fi
}

install_packages() {
  local packages=("$@")

  if have apt-get; then
    use_sudo apt-get update
    use_sudo apt-get install -y "${packages[@]}"
    return
  fi

  if have dnf; then
    use_sudo dnf install -y "${packages[@]}"
    return
  fi

  if have pacman; then
    use_sudo pacman -Sy --noconfirm "${packages[@]}"
    return
  fi

  if have zypper; then
    use_sudo zypper install -y "${packages[@]}"
    return
  fi

  echo "No reconozco el gestor de paquetes. Instala manualmente: ${packages[*]}" >&2
  exit 1
}

ensure_build_toolchain() {
  step "Comprobando toolchain para Treesitter"

  if have cc || have gcc || have clang; then
    echo "Compilador C ya disponible."
    return
  fi

  if have apt-get; then
    install_packages build-essential
    return
  fi

  if have dnf; then
    install_packages gcc gcc-c++ make
    return
  fi

  if have pacman; then
    install_packages base-devel
    return
  fi

  if have zypper; then
    install_packages gcc gcc-c++ make
    return
  fi

  echo "No pude instalar automaticamente un compilador C. Instala gcc/clang y make manualmente." >&2
  exit 1
}

ensure_fd_alias() {
  if have fd; then
    return
  fi

  if have fdfind; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    export PATH="$HOME/.local/bin:$PATH"
    return
  fi
}

ensure_command() {
  local command_name="$1"
  shift
  local packages=("$@")

  if have "$command_name"; then
    echo "$command_name ya esta disponible."
    return
  fi

  step "Instalando $command_name"
  install_packages "${packages[@]}"
  ensure_fd_alias

  if ! have "$command_name"; then
    echo "No encuentro '$command_name' tras instalar ${packages[*]}." >&2
    exit 1
  fi
}

run_nvim_sync() {
  NVIM_APPNAME="$repo_name" XDG_CONFIG_HOME="$config_home" nvim --headless "+Lazy! sync" "+qa"
}

step "Validando repositorio"
assert_repo_shape

step "Comprobando dependencias base"
ensure_command git git
configure_git_hooks
ensure_command nvim neovim
ensure_command rg ripgrep
ensure_build_toolchain

if have apt-get; then
  ensure_command fd fd-find
else
  ensure_command fd fd
fi

step "Sincronizando plugins y herramientas de Neovim"
run_nvim_sync

if [[ "$post_merge" -eq 1 ]]; then
  printf '\nHook post-merge ejecutado correctamente.\n'
  printf 'Siguiente paso recomendado:\n'
  printf '  cd %q\n' "$repo_root"
  printf '  NVIM_APPNAME=%q XDG_CONFIG_HOME=%q nvim\n' "$repo_name" "$config_home"
  printf 'Y dentro de Neovim:\n'
  printf '  :Mason\n'
  printf '  :TSUpdate\n'
  exit 0
fi

step "Versiones detectadas"
git --version
nvim --version | head -n 1
fd --version
rg --version | head -n 1

printf '\nListo. Ahora ejecuta esto en consola:\n'
printf '  cd %q\n' "$repo_root"
printf '  NVIM_APPNAME=%q XDG_CONFIG_HOME=%q nvim\n' "$repo_name" "$config_home"
printf 'Y dentro de Neovim ejecuta:\n'
printf '  :Mason\n'
printf '  :TSUpdate\n'
