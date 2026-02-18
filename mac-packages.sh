#!/usr/bin/env bash
# Install Homebrew packages on macOS

set -euo pipefail

# Formulae
packages=(
  antidote
  aria2
  awscli
  bat
  btop
  cmake
  cmatrix
  duf
  dust
  entr
  eza
  fd
  ffmpeg
  fzf
  git-delta
  git-lfs
  graphviz
  handbrake
  hashicorp/tap/terraform
  helm
  httpie
  jq
  k9s
  kubernetes-cli
  lazydocker
  lazygit
  mpv
  neovim
  node
  opencode
  oven-sh/bun/bun
  pandoc
  pipx
  python@3.14
  rclone
  ripgrep
  scc
  syncthing
  tldr
  tmux
  tree
  yq
  zellij
  zoxide
)

# Casks
casks=(
  bitwarden
  codex
  cursor
  cyberduck
  datweatherdoe
  dbeaver-community
  discord
  ghostty
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
  transmission
  visual-studio-code
  zed
  zen
)

echo "Installing brew packages..."
brew install "${packages[@]}"

echo "Installing brew casks..."
brew install --cask "${casks[@]}"

echo "All done"
