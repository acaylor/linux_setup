#!/bin/bash

# Disable services that are typically unused on headless VM servers
sudo systemctl disable --now ModemManager.service
sudo systemctl disable --now udisks2.service
sudo systemctl disable --now multipathd.service

# Disable automatic apt update/upgrade timers for manual control
sudo systemctl disable --now apt-daily.service apt-daily.timer
sudo systemctl disable --now apt-daily-upgrade.service apt-daily-upgrade.timer

# Cap journald retention; logs are forwarded for long-term storage
sudo install -d -m 0755 /etc/systemd/journald.conf.d
sudo tee /etc/systemd/journald.conf.d/99-vm.conf >/dev/null <<'EOF'
[Journal]
SystemMaxUse=50M
RuntimeMaxUse=50M
EOF
sudo systemctl restart systemd-journald.service

# Ensure the system boots to a non-graphical target
sudo systemctl set-default multi-user.target
