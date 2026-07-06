#!/usr/bin/env bash
# Install Homebrew packages on macOS

set -euo pipefail

# Taps
taps=(
  hashicorp/tap
  homebrew/services
  oven-sh/bun
)

# Formulae
packages=(
  antidote
  aria2
  awscli
  bat
  btop
  cmake
  cmatrix
  ctop
  d2
  duf
  dust
  entr
  eza
  fd
  ffmpeg
  fzf
  gemini-cli
  gh
  git-delta
  git-lfs
  go
  graphviz
  gstreamer
  handbrake
  hashicorp/tap/terraform
  helm
  httpie
  jq
  k9s
  kubernetes-cli
  lazydocker
  lazygit
  lychee
  mpv
  neovim
  node
  node_exporter
  opencode
  oven-sh/bun/bun
  pandoc
  pipx
  pnpm
  popeye
  prometheus
  python@3.10
  python@3.14
  rclone
  renovate
  ripgrep
  scc
  syncthing
  tea
  tldr
  tmux
  tree
  uv
  xz
  yq
  zellij
  zoxide
)

# Casks
casks=(
  bitwarden
  claude
  claude-code@latest
  codex
  codex-app
  cursor
  cyberduck
  datweatherdoe
  dbeaver-community
  discord
  ghostty
  godot
  google-chrome
  insomnia
  keka
  lm-studio
  obsidian
  orbstack
  pearcleaner
  raspberry-pi-imager
  rectangle
  stats
  steam
  thaw
  transmission
  zed
  zen
)

echo "Tapping brew repositories..."
for tap in "${taps[@]}"; do
  brew tap "$tap"
done

echo "Installing brew packages..."
brew install "${packages[@]}"

echo "Installing brew casks..."
brew install --cask "${casks[@]}"

echo "All done"
