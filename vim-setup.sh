#!/usr/bin/env bash

set -e

git clone --depth=1 https://github.com/amix/vimrc.git ~/.vim_runtime
#sh ~/.vim_runtime/install_awesome_vimrc.sh

echo "plugins go into ~/.vim_runtime/my_plugins/"

# cd ~/.vim_runtime
# git clone git://github.com/tpope/vim-rails.git my_plugins/vim-rails

# Terraform plugin
# git clone https://github.com/hashivim/vim-terraform.git ~/.vim_runtime/my_plugins/vim-terraform

# git clone https://github.com/NLKNguyen/papercolor-theme.git ~/.vim_runtime/my_plugins/papercolor-theme

# Upgrade vimrc
# cd ~/.vim_runtime
# git reset --hard
# git clean -d --force
# git pull --rebase
# python update_plugins.py  # use python3 if python is unavailable
