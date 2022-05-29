#!/usr/bin/env bash

set -e

sudo dnf install python3 python3-pip

python3 -m pip install -U --user ansible
