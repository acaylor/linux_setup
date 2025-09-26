#!/usr/bin/env bash
# Install Homebrew packages on macOS

set -euo pipefail

# Formulae
packages=(
  alloy
  awscli
  bat
  btop
  cmatrix
  codex
  dust
  eza
  fzf
  git
  git-lfs
  graphviz
  handbrake
  helm
  httpie
  jq
  jsonnet
  jupyterlab
  k9s
  kubernetes-cli
  lua
  macchina
  mpv
  neovim
  node
  node_exporter
  pandoc
  popeye
  prometheus
  python@3.13
  ripgrep
  ruby
  sqlite
  sshpass
  syncthing
  terraform
  tmux
  tree-sitter
  vim
  xz
  yq
)

# Casks
casks=(
  arc
  betterdisplay
  bitwarden
  chromium
  claude
  cursor
  cyberduck
  dbeaver-community
  devutils
  discord
  docker-desktop
  ghostty
  google-chrome
  handbrake
  handbrake-app
  insomnia
  iterm2
  keka
  kitty
  librewolf
  msty
  obsidian
  parsec
  pearcleaner
  pycharm-ce
  raspberry-pi-imager
  raycast
  rectangle
  stats
  steam
  upscayl
  utm
  visual-studio-code
  zen
  zenmap
)

echo "Installing brew packages..."
brew install "${packages[@]}"

echo "Installing brew casks..."
brew install --cask "${casks[@]}"

echo "All done"