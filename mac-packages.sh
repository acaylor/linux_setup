#!/usr/bin/env bash
# Install homebrew packages on a mac


packages=(
bat
btop
fzf
git
git-lfs
neovim
pandoc
python@3.12
the_silver_searcher
tmux
tree
vim
)

# I removed some from this list as they are
# not suitable for my desktop mac
other_packages=(
httpie
syncthing
terraform
)

casks=(
kitty
rectangle
)

# I removed some from this list as they are
# not suitable for my desktop mac
other_casks=(
istat-menus
iterm2
visual-studio-code
obsidian
)

printf "Installing brew packages"
brew install $packages

printf "Done installing brew packages"

printf "installing brew cask packages"
brew install --cask $casks
