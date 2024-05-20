#!/usr/bin/env bash
set -e

echo "Installing Software packages"

sudo dnf install \
	steam \
	neovim \
	btop \
	htop \
	nvtop \
	lm_sensors \
	mpv \
	cmatrix

echo "done"
