#!/bin/bash
USER=$(whoami)
HOSTNAME=$(uname -n)
USERS=$(users | wc -w)

# Weather with timeout
WEATHER=$(timeout 2 curl -s wttr.in/Denver?format=3 2>/dev/null || echo "Weather unavailable")

# Time greeting
HOUR=$(date +"%H")
case $HOUR in
  0[0-9] | 1[01]) TIME="morning" ;;
  1[2-6]) TIME="afternoon" ;;
  *) TIME="evening" ;;
esac

# System metrics
read -r load1 load5 load15 _ </proc/loadavg

# Memory calculation (handle missing MemAvailable on older systems)
if grep -q "MemAvailable" /proc/meminfo; then
  read -r _ mem_total _ </proc/meminfo
  read -r _ mem_available _ < <(grep MemAvailable /proc/meminfo)
  mem_used_pct=$(((mem_total - mem_available) * 100 / mem_total))
else
  # Fallback for older systems without MemAvailable
  mem_info=$(free | grep '^Mem:')
  mem_total=$(echo "$mem_info" | awk '{print $2}')
  mem_used=$(echo "$mem_info" | awk '{print $3}')
  mem_used_pct=$((mem_used * 100 / mem_total))
fi

# Disk usage - escape parentheses properly
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')

# Output
printf 'Good %s %s\n' "$TIME" "$USER"
printf "
====================================================================================================
\n"

# Check if macchina exists, otherwise show OS info
if command -v macchina &>/dev/null; then
  macchina
else
  # Get OS information
  if [[ -f /etc/os-release ]]; then
    # shellcheck source=/dev/null
    source /etc/os-release
    OS_NAME="$NAME"
    OS_VERSION="$VERSION"
  elif [[ -f /etc/lsb-release ]]; then
    # shellcheck source=/dev/null
    source /etc/lsb-release
    OS_NAME="$DISTRIB_ID"
    OS_VERSION="$DISTRIB_RELEASE"
  else
    OS_NAME=$(uname -s)
    OS_VERSION="Unknown"
  fi

  KERNEL=$(uname -r)
  ARCH=$(uname -m)

  printf '   OS...........................................: %s %s\n' "$OS_NAME" "$OS_VERSION"
  printf '   Kernel.......................................: %s\n' "$KERNEL"
  printf '   Architecture.................................: %s\n' "$ARCH"
  printf '   Hostname.....................................: %s\n' "$HOSTNAME"
fi

printf "
====================================================================================================
\n"

printf '   Users...........................................: Currently %s user(s) logged on\n' "$USERS"
printf '   Load Average....................................: %s, %s, %s (1, 5, 15 mins)\n' "$load1" "$load5" "$load15"
printf '   Memory Usage....................................: %s%% used\n' "$mem_used_pct"
printf "   Disk Usage......................................: %s\n" "$DISK_USAGE"
printf '   Weather.........................................: %s\n' "$WEATHER"
printf "
====================================================================================================
"
