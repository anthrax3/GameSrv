#!/bin/bash

# Check the effective user id to see if it's root (EUID works with sudo, UID does not)
if (( EUID != 0 )); then
   echo "######## ########  ########   #######  ########"
   echo "##       ##     ## ##     ## ##     ## ##     ##"
   echo "##       ##     ## ##     ## ##     ## ##     ##"
   echo "######   ########  ########  ##     ## ########"
   echo "##       ##   ##   ##   ##   ##     ## ##   ##"
   echo "##       ##    ##  ##    ##  ##     ## ##    ##"
   echo "######## ##     ## ##     ##  #######  ##     ##"
   echo ""
   echo ""
   echo "####### ERROR: ROOT PRIVILEGES REQUIRED #########"
   echo "This script must be run as root to work properly!"
   echo "You could also try running 'sudo ./start.sh' too."
   echo "##################################################"
   echo ""
   exit 1
fi

# Check for Directory and PID and if not create gamesrv directory
if [ -d /var/run/"$gamesrv" ]; then
   # Create a PID file to keep track of what the process ID is 
  echo $$ >> /var/run/gamesrv/start_sh.pid
# Makes gamesrv directory in /var/run to place our pid file
else [ mkdir -p /var/run/gamesrv ];
  # Creates a PID file to keep track of what the process ID is
  echo $$ >> /var/run/gamesrv/start_sh.pid
fi
## for DOSEMU -- may be able to comment out in newer releases
sysctl -w vm.mmap_min_addr="0"

cd /gamesrv
# Runs our DOS application as user and group gamesrv using mono
# The & lets the process run in the background
privbind -u gamesrv -g gamesrv mono GameSrvConsole.exe DEBUG &
