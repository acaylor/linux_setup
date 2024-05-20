#!/usr/bin/env bash
set -e

echo "update dnf config"
echo "allowing 10 parallel downloads"
echo "max_parallel_downloads=10" | sudo tee -a /etc/dnf/dnf.conf
echo "enabling fastest mirror selection"
echo "fastestmirror=True" | sudo tee -a /etc/dnf/dnf.conf

echo "Installing Software packages"

sudo dnf install \
	foot \
	vim \
	zsh \
	tmux \
	unzip \
	p7zip \
	p7zip-plugins \
	unrar 

echo "Installing fonts"

sudo dnf install \
	google-roboto-fonts \
	fira-code-fonts

echo "Installing gnome stuff"

sudo dnf install \
	gnome-tweaks \
	gnome-extensions-app \
	gnome-shell-extension-caffeine \
	gnome-shell-extension-user-theme

echo "Making theme dir for user $USER"

mkdir -p ~/.themes

