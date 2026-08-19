#!/usr/bin/env bash
# Provision Fedora's system baseline and the mise-managed user toolchain.
#
# The mise manifest next to this script is authoritative for developer-facing
# runtimes and CLIs. Fedora packages remain responsible for the operating
# system, drivers, desktop, services, shared libraries, and bootstrap tooling.

set -euo pipefail

if [[ ! -r /etc/os-release ]] || \
  [[ $(. /etc/os-release && printf '%s' "$ID") != fedora ]]; then
  printf 'This script supports Fedora only.\n' >&2
  exit 1
fi

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
manifest="$script_dir/mise/linux-workstation.toml"
global_config="$HOME/.config/mise/config.toml"

if [[ ! -f $manifest ]]; then
  printf 'Missing mise manifest: %s\n' "$manifest" >&2
  exit 1
fi

sudo dnf install --assumeyes \
  ca-certificates \
  curl \
  entr \
  ffmpeg-free \
  gcc \
  gcc-c++ \
  git \
  graphviz \
  make \
  patch \
  pkgconf-pkg-config \
  rsync \
  tree \
  unzip \
  util-linux \
  xz \
  zsh

if [[ ! -d $HOME/.antidote/.git ]]; then
  git clone --depth=1 https://github.com/mattmc3/antidote.git "$HOME/.antidote"
fi

mkdir -p "$HOME/.local/bin" "$HOME/.config/mise"
if [[ ! -x $HOME/.local/bin/mise ]]; then
  curl --proto '=https' --tlsv1.2 -fsSL https://mise.run | sh
fi

export PATH="$HOME/.local/bin:$PATH"

# Preserve a dated copy before replacing a locally edited inventory so manual
# additions remain visible after rerunning the bootstrap.
if [[ -f $global_config ]] && ! cmp -s "$manifest" "$global_config"; then
  backup="$global_config.before-bootstrap.$(date +%Y%m%d%H%M%S)"
  cp "$global_config" "$backup"
  printf 'Backed up the previous mise config to %s\n' "$backup"
fi
install -m 0644 "$manifest" "$global_config"

ensure_line() {
  local file=$1 line=$2
  touch "$file"
  grep -Fqx "$line" "$file" || printf '\n%s\n' "$line" >> "$file"
}

ensure_line "$HOME/.bashrc" 'eval "$("$HOME/.local/bin/mise" activate bash)"'
ensure_line "$HOME/.zshrc" 'eval "$("$HOME/.local/bin/mise" activate zsh)"'

# Persist Zsh history even when this is the only dotfile installed by the
# bootstrap. A fuller dotfile setup may source the same idempotent options.
zsh_config_dir="$HOME/.config/zsh"
history_config="$script_dir/dotfiles/config/zsh/history.zsh"
if [[ -f $history_config ]]; then
  mkdir -p "$zsh_config_dir"
  install -m 0644 "$history_config" "$zsh_config_dir/history.zsh"
  ensure_line "$HOME/.zshrc" '[[ -r "$HOME/.config/zsh/history.zsh" ]] && source "$HOME/.config/zsh/history.zsh"'
fi

mise install --yes
sudo chsh -s "$(command -v zsh)" "$USER"

printf '\nBootstrap complete. Start a new shell, then run `mise current`.\n'
