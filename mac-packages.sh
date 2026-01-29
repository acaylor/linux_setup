#!/usr/bin/env bash
# Install Homebrew packages on macOS

set -euo pipefail

# Formulae
packages=(
  antidote
  awscli
  bat
  btop
  cmake
  cmatrix
  dust
  eza
  fd
  fzf
  git-lfs
  graphviz
  helm
  httpie
  jq
  k9s
  kubernetes-cli
  lazydocker
  lazygit
  handbrake
  neovim
  node
  opencode
  oven-sh/bun/bun
  pipx
  python@3.14
  ripgrep
  syncthing
  tmux
  tree
  yq
)

# Casks
casks=(
  bitwarden
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
  zen
  zed
)

echo "Installing brew packages..."
brew install "${packages[@]}"

echo "Installing brew casks..."
brew install --cask "${casks[@]}"

echo "All done"
