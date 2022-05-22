#!/usr/bin/env bash

set -e

sudo dnf install dnf-plugins-core

sudo dnf config-manager --add-repo https://rpm.releases.hashicorp.com/fedora/hashicorp.repo

sudo dnf install terraform
