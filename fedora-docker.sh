#!/usr/bin/env bash

set -e
RED='\e[1;31m'
NOCL='\e[0m'

echo -e "$RED remove old versions of docker if installed $NOCL"
sudo dnf remove docker \
                  docker-client \
                  docker-client-latest \
                  docker-common \
                  docker-latest \
                  docker-latest-logrotate \
                  docker-logrotate \
                  docker-engine-selinux \
                  docker-engine
                  #docker-selinux \ was removed

echo -e "$RED install dnf core utilities $NOCL"

echo -e "$RED verify GPG key signature: 060A 61C5 1B55 8A7F 742B 77AA C52F EB6B 621E 9F35 $NOCL"
echo -e "$RED install docker engine and compose plugin $NOCL"
sudo dnf install docker-ce docker-ce-cli containerd.io docker-compose-plugin

echo -e "$RED done - now add $USER to the group: docker $NOCL"

echo -e "$RED enable docker daemon $NOCL"
sudo systemctl enable --now docker
