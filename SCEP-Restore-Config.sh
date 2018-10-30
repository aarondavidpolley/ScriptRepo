#!/bin/bash

#SCEP = Microsoft System Center Endpoint Protection for Mac
#Designed to work with v4.5.32.0, may work with earlier versions
#Purpose: Restore configuration post installation (useful for mass deployment)

echo "Starting SCEP config restore..."

WHOAREYOU=$(whoami)

if [ "$WHOAREYOU" != "root" ]; then

echo "ERROR: Need to run with sudo"

exit 1

fi

DATETIME=$(date '+%Y-%m-%d_%H-%M-%S')

loggedInUser=$(/bin/ls -l /dev/console | /usr/bin/awk '{ print $3 }')

uid=$(id -u "$loggedInUser")

echo "Detected current user as $loggedInUser with UID $uid"

echo "Backing up current config"

/Applications/System\ Center\ Endpoint\ Protection.app/Contents/MacOS/scep_set --backup=/tmp/SCEP_Settings_Export_$DATETIME.txt

sleep 3

echo "Created /tmp/SCEP_Settings_Export_$DATETIME.txt"

echo "Unloading user agent"

launchctl asuser "$uid" chroot -u "$uid" / launchctl unload /Library/LaunchAgents/com.microsoft.scep_gui.plist

echo "Unloading system daemon"

launchctl unload /Library/LaunchDaemons/com.microsoft.scep_daemon.plist

sleep 3

echo "Killing any rogue processes"

pkill -f "System Center Endpoint Protection"

sleep 3

echo "Restoring config file"

/Applications/System\ Center\ Endpoint\ Protection.app/Contents/MacOS/scep_set --apply=/tmp/SCEP_Settings_Import

sleep 3

echo "Loading system daemon"

launchctl load -w /Library/LaunchDaemons/com.microsoft.scep_daemon.plist

sleep 3

echo "Loading user agent"

launchctl asuser "$uid" chroot -u "$uid" / launchctl load -w /Library/LaunchAgents/com.microsoft.scep_gui.plist



