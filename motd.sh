#!/bin/bash
USER=$(whoami)
HOSTNAME=$(uname -n)
uptime=$(cat /proc/uptime | cut -f1 -d.)
upDays=$(($uptime/60/60/24))
upHours=$(($uptime/60/60%24))
upMins=$(($uptime/60%60))
upSecs=$(($uptime%60))
LOAD1=$(cat /proc/loadavg | awk {'print $1'})
LOAD5=$(cat /proc/loadavg | awk {'print $2'})
LOAD15=$(cat /proc/loadavg | awk {'print $3'})
USERS=$(users | wc -w)
#RELEASE=$(cat /etc/redhat-release || uname -sr)
WEATHER=$(curl -s wttr.in/Denver?format=3)
HOUR=$(date +"%H")
if [ $HOUR -lt 12 -a $HOUR -ge 0 ]
then TIME="morning"
elif [ $HOUR -lt 17 -a $HOUR -ge 12 ]
then TIME="afternoon"
else
        TIME="evening"
fi

RED='\e[0;41m'
NC='\e[0m'

# Output below
printf "Good $TIME $USER\n"
printf "
====================================================================================================
\n"
#/usr/bin/neofetch
./pfetch
printf "
====================================================================================================
\n"
#printf "    Hostname........................................: $HOSTNAME\n"
#printf "    Current user....................................: $USER\n"
printf "   Users...........................................: Currently $USERS user(s) logged on\n"
printf "   Load Average....................................: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 mins)\n"
printf "   Weather.........................................: $WEATHER\n"
printf "
====================================================================================================
"
