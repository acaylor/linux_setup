#!/usr/bin/env bash

set -e

# Microsoft rpm gpg key
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
# Add repo for vscode
sudo sh -c 'echo -e "[code]\nname=Visual Studio Code\nbaseurl=https://packages.microsoft.com/yumrepos/vscode\nenabled=1\ngpgcheck=1\ngpgkey=https://packages.microsoft.com/keys/microsoft.asc" > /etc/yum.repos.d/vscode.repo'

wait 2

# install vs code
sudo dnf check-update
sudo dnf install code
