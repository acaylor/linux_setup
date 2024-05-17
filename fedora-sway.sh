#!/usr/bin/env bash

sudo dnf group install "Sway Desktop"

# default config for sway
sudo dnf install sway-config-fedora

# default config is in /etc/sway/config