#!/usr/bin/env bash
# Bootstrap the same mise-managed workstation on macOS, Ubuntu, or Fedora.

set -euo pipefail

script_dir=$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)
manifest="$script_dir/mise/workstation.toml"
kubediagrams_overrides="$script_dir/mise/kubediagrams-overrides.txt"
# mise reads its global config from the XDG config directory, and the manifest
# locates the KubeDiagrams override through `{{ xdg_config_home }}`. Derive one
# config root here so both files land where mise actually looks for them.
config_home="${XDG_CONFIG_HOME:-$HOME/.config}"
global_config="$config_home/mise/config.toml"
global_kubediagrams_overrides="$config_home/mise/kubediagrams-overrides.txt"
mise_bin="$HOME/.local/bin/mise"

for required_file in "$manifest" "$kubediagrams_overrides"; do
  if [[ ! -f $required_file ]]; then
    printf 'Missing workstation configuration: %s\n' "$required_file" >&2
    exit 1
  fi
done

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

mkdir -p "$HOME/.local/bin" "$config_home/mise"
if [[ ! -x $mise_bin ]]; then
  curl --proto '=https' --tlsv1.2 -fsSL https://mise.run \
    | MISE_INSTALL_PATH="$mise_bin" sh
else
  "$mise_bin" self-update --yes --no-plugins
fi

export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"

# Noninteractive Zsh sessions (including `ssh host command`) read ~/.zshenv but
# not ~/.zshrc. Login setup such as brew shellenv or OrbStack may reorder PATH,
# so ~/.zprofile reasserts the same precedence after those machine-local edits.
# The literal expression is written into shell startup files for later expansion.
# shellcheck disable=SC2016
mise_path_line='export PATH="$HOME/.local/share/mise/shims:$HOME/.local/bin:$PATH"'
mise_path_comment='# Keep mise-managed tools ahead of system package-manager paths.'

for zsh_startup_file in "$HOME/.zshenv" "$HOME/.zprofile"; do
  touch "$zsh_startup_file"
  if ! grep -Fqx "$mise_path_line" "$zsh_startup_file"; then
    printf '\n%s\n%s\n' "$mise_path_comment" "$mise_path_line" \
      >>"$zsh_startup_file"
  fi
done

# Bash needs the same PATH, but it must come first: `mise bootstrap` writes
# `eval "$(mise activate bash --shims)"` into ~/.bash_profile, and once that
# file exists Bash login shells stop reading ~/.profile, which is what normally
# puts ~/.local/bin on PATH. Without this the next Bash login cannot find mise
# at all. Prepend rather than append so the export runs before that eval.
for bash_startup_file in "$HOME/.bash_profile" "$HOME/.bashrc"; do
  touch "$bash_startup_file"
  if ! grep -Fqx "$mise_path_line" "$bash_startup_file"; then
    prepended=$(mktemp)
    printf '%s\n%s\n\n' "$mise_path_comment" "$mise_path_line" >"$prepended"
    cat "$bash_startup_file" >>"$prepended"
    cat "$prepended" >"$bash_startup_file"
    rm -f "$prepended"
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
install -m 0644 "$kubediagrams_overrides" "$global_kubediagrams_overrides"

# Keep portable Zsh fragments aligned without replacing the user's whole
# ~/.zshrc, which may contain machine-local initialization and credentials.
zsh_config_dir="$config_home/zsh"
mkdir -p "$zsh_config_dir"
for config in "$script_dir"/dotfiles/config/zsh/*.zsh; do
  install -m 0644 "$config" "$zsh_config_dir/$(basename "$config")"
done

"$mise_bin" bootstrap --yes "$@"

# Installing the fragments is not enough: `mise bootstrap` generates a ~/.zshrc
# that contains only its own activation block, and the source loop lives in
# dotfiles/zshrc, which this script deliberately does not install. Add a small
# managed block so fresh hosts actually load the fragments.
zshrc="${ZDOTDIR:-$HOME}/.zshrc"
zshrc_marker='# >>> linux_setup zsh fragments >>>'
touch "$zshrc"
if ! grep -Fq "$zshrc_marker" "$zshrc"; then
  cat >>"$zshrc" <<EOF

$zshrc_marker
# Managed by workstation-bootstrap.sh. Edit the fragments, not this block.
for _linux_setup_fragment in "\${XDG_CONFIG_HOME:-\$HOME/.config}"/zsh/*.zsh(N); do
  source "\$_linux_setup_fragment"
done
unset _linux_setup_fragment
# <<< linux_setup zsh fragments <<<
EOF
fi

# The backticks below are documentation, not command substitution.
# shellcheck disable=SC2016
printf '\nBootstrap complete. Start a new shell, then run `mise doctor`.\n'
