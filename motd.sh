#!/bin/bash
USER=$(whoami)
HOSTNAME=$(uname -n)
USERS=$(users | wc -w)

# System uptime
read uptime_raw idle_raw < /proc/uptime
uptime=${uptime_raw%.*}  # Remove decimal part, keep only uptime (first value)
upDays=$((uptime/60/60/24))
upHours=$((uptime/60/60%24))
upMins=$((uptime/60%60))
upSecs=$((uptime%60))

# Weather with timeout
WEATHER=$(timeout 2 curl -s wttr.in/Denver?format=3 2>/dev/null || echo "Weather unavailable")

# Time greeting
HOUR=$(date +"%H")
case $HOUR in
  0[0-9]|1[01]) TIME="morning" ;;
  1[2-6]) TIME="afternoon" ;;
  *) TIME="evening" ;;
esac

# System metrics
read load1 load5 load15 _ < /proc/loadavg

# Memory calculation (handle missing MemAvailable on older systems)
if grep -q "MemAvailable" /proc/meminfo; then
    read -r _ mem_total _ < /proc/meminfo
    read -r _ mem_available _ < <(grep MemAvailable /proc/meminfo)
    mem_used_pct=$(( (mem_total - mem_available) * 100 / mem_total ))
else
    # Fallback for older systems without MemAvailable
    mem_info=$(free | grep '^Mem:')
    mem_total=$(echo $mem_info | awk '{print $2}')
    mem_used=$(echo $mem_info | awk '{print $3}')
    mem_used_pct=$(( mem_used * 100 / mem_total ))
fi

# Disk usage - escape parentheses properly
DISK_USAGE=$(df -h / | awk 'NR==2 {print $3 "/" $2 " (" $5 ")"}')

# Colors
RED='\e[0;41m'
NC='\e[0m'

# Output
printf "Good $TIME $USER\n"
printf "
====================================================================================================
\n"

# Check if macchina exists, otherwise show OS info
if command -v macchina &>/dev/null; then
    macchina
else
    # Get OS information
    if [[ -f /etc/os-release ]]; then
        source /etc/os-release
        OS_NAME="$NAME"
        OS_VERSION="$VERSION"
    elif [[ -f /etc/lsb-release ]]; then
        source /etc/lsb-release
        OS_NAME="$DISTRIB_ID"
        OS_VERSION="$DISTRIB_RELEASE"
    else
        OS_NAME=$(uname -s)
        OS_VERSION="Unknown"
    fi

    KERNEL=$(uname -r)
    ARCH=$(uname -m)

    printf "   OS...........................................: $OS_NAME $OS_VERSION\n"
    printf "   Kernel.......................................: $KERNEL\n"
    printf "   Architecture.................................: $ARCH\n"
    printf "   Hostname.....................................: $HOSTNAME\n"
fi

printf "
====================================================================================================
\n"

printf "   Users...........................................: Currently $USERS user(s) logged on\n"
printf "   Load Average....................................: $load1, $load5, $load15 (1, 5, 15 mins)\n"
printf "   Memory Usage....................................: ${mem_used_pct}%% used\n"
printf "   Disk Usage......................................: %s\n" "$DISK_USAGE"
printf "   Weather.........................................: $WEATHER\n"
printf "
====================================================================================================
"
