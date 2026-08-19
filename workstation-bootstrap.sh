#!/usr/bin/env bash
# Bootstrap the same mise-managed workstation on macOS, Ubuntu, or Fedora.

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
manifest="$script_dir/mise/workstation.toml"
global_config="$HOME/.config/mise/config.toml"
mise_bin="$HOME/.local/bin/mise"

if [[ ! -f $manifest ]]; then
  printf 'Missing workstation manifest: %s\n' "$manifest" >&2
  exit 1
fi

if ! command -v curl >/dev/null 2>&1; then
  if command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update
    sudo env DEBIAN_FRONTEND=noninteractive apt-get install --yes ca-certificates curl
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install --assumeyes ca-certificates curl
  else
    printf 'curl is required to install mise. Install it and rerun this script.\n' >&2
    exit 1
  fi
fi

mkdir -p "$HOME/.local/bin" "$HOME/.config/mise"
if [[ ! -x $mise_bin ]]; then
  curl --proto '=https' --tlsv1.2 -fsSL https://mise.run |
    MISE_INSTALL_PATH="$mise_bin" sh
else
  "$mise_bin" self-update --yes --no-plugins
fi

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# Noninteractive Zsh sessions (including `ssh host command`) read ~/.zshenv but
# not ~/.zshrc. Login setup such as brew shellenv or OrbStack may reorder PATH,
# so ~/.zprofile reasserts the same precedence after those machine-local edits.
mise_path_line='export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"'
for zsh_startup_file in "$HOME/.zshenv" "$HOME/.zprofile"; do
  touch "$zsh_startup_file"
  if ! grep -Fqx "$mise_path_line" "$zsh_startup_file"; then
    printf '\n# Keep mise-managed tools ahead of system package-manager paths.\n%s\n' \
      "$mise_path_line" >>"$zsh_startup_file"
  fi
done

# Preserve local experimentation, then install the repository copy as the
# global config. The repository remains the only file edited by hand.
if [[ -f $global_config ]] && ! cmp -s "$manifest" "$global_config"; then
  backup="$global_config.before-bootstrap.$(date +%Y%m%d%H%M%S)"
  cp "$global_config" "$backup"
  printf 'Backed up the previous mise config to %s\n' "$backup"
fi
install -m 0644 "$manifest" "$global_config"

# Keep portable Zsh fragments aligned without replacing the user's whole
# ~/.zshrc, which may contain machine-local initialization and credentials.
zsh_config_dir="$HOME/.config/zsh"
mkdir -p "$zsh_config_dir"
for config in "$script_dir"/dotfiles/config/zsh/*.zsh; do
  install -m 0644 "$config" "$zsh_config_dir/$(basename "$config")"
done

"$mise_bin" bootstrap --yes "$@"

printf '\nBootstrap complete. Start a new shell, then run `mise doctor`.\n'
