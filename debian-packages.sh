#!/usr/bin/env bash
#
#Install packages that I like

packages=(bat
btop
curl
flatpak
fzf
git
git-lfs
htop
kitty
mpv
nvtop
openresolv
pandoc
python3-pip
python3-venv
rsync
tmux
tree
vim
wireguard
zsh
)

echo "Installing packages... \n"

sudo apt install ${packages[*]}
