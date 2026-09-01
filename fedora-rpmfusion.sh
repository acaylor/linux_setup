#!/usr/bin/env bash
# https://rpmfusion.org/configuration

# free and non free rpm repos installed via dnf
fedora_release=$(rpm -E %fedora)
sudo dnf install \
  "https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-${fedora_release}.noarch.rpm" \
  "https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-${fedora_release}.noarch.rpm"

# AppStream metadata
sudo dnf groupupdate core

# multimedia package groups
sudo dnf groupupdate multimedia --setop="install_weak_deps=False" --exclude=PackageKit-gstreamer-plugin
sudo dnf groupupdate sound-and-video

# tainted repos
# sudo dnf install rpmfusion-free-release-tainted
# sudo dnf install libdvdcss
# sudo dnf install rpmfusion-nonfree-release-tainted
# sudo dnf install \*-firmware
