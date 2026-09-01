#!/bin/bash
USER=$(whoami)
HOSTNAME=$(uname -n)
read -r LOAD1 LOAD5 LOAD15 _ </proc/loadavg
USERS=$(users | wc -w)
#RELEASE=$(cat /etc/redhat-release || uname -sr)
WEATHER=$(curl -s wttr.in/Atlanta?format=3)
HOUR=$(date +"%H")
case $HOUR in
  0[0-9] | 1[01]) TIME="morning" ;;
  1[2-6]) TIME="afternoon" ;;
  *) TIME="evening" ;;
esac

# Output below
echo "Good $TIME $USER"
echo "
=========================================================================================
"
#/usr/bin/neofetch
echo "
=========================================================================================
"
echo "- Hostname........................................: $HOSTNAME"
#echo "- Current user....................................: $USER"
echo "- Users...........................................: Currently $USERS user(s) logged on"
echo "- Load Average....................................: $LOAD1, $LOAD5, $LOAD15 (1, 5, 15 mins)"
echo "- Weather.........................................: $WEATHER"
echo "
=========================================================================================
"
