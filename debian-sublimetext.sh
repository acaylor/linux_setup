#!/usr/bin/env bash

# Install GPG key from sublime text maintainer
wget -qO - https://download.sublimetext.com/sublimehq-pub.gpg | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/sublimehq-archive.gpg > /dev/null

# add apt repo
echo "deb https://download.sublimetext.com/ apt/stable/" | sudo tee /etc/apt/sources.list.d/sublime-text.list

# install package
sudo apt-get update
sudo apt-get install sublime-text

# might need these packages
# apt-get install apt-transport-https
