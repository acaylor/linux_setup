#!/usr/bin/env bash
set -e

#chsh -s /bin/zsh

echo "Install oh my zsh"
sh -c "$(wget https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh -O -)"

echo "Install Powerlevel10k theme"
git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
sed -i 's/_THEME=\"robbyrussell\"/_THEME=\"powerlevel10k\/powerlevel10k\"/g' ~/.zshrc
source ~/.zshrc

echo "Done setting up zsh"
