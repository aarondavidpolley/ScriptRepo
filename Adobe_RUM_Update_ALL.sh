#!/bin/sh

#Script Version: 2.0
#Script Author: Aaron Polley, CompNow, 2019-12-12

#Log file for RUM run that will be displayed at the end
log_file="/var/log/AdobeRUM.log"

touch "$log_file"

chmod 755 $log_file

FINDER_PROCESS=$(pgrep -l "Finder")

if [ "$FINDER_PROCESS" != "" ]
then
	# Open the log file for all logged in users
    for pid_uid in $(ps -axo pid,uid,args | grep -i "[l]oginwindow.app" | awk '{print $1 "," $2}'); do
        pid=$(echo $pid_uid | cut -d, -f1)
        uid=$(echo $pid_uid | cut -d, -f2)
        # Replace echo with e.g. launchctl load.
        launchctl asuser "$uid" chroot -u "$uid" / open "$log_file"
    done
    	
fi



#---Redirect output to log and shell---#
{

echo "***************************************************************************************"
echo "***Run Start***"
date
echo "***************************************************************************************"

if [ ! -e /usr/local/bin/RemoteUpdateManager ]
then
	echo "ERROR: RUM binary is missing, not proceeding with updates"
	exit 1
fi

	echo "Running Adobe Remote Update Manager from local cache"

	/usr/local/bin/RemoteUpdateManager --action=list
	
	sleep 1
	
	/usr/local/bin/RemoteUpdateManager --action=install

echo "***************************************************************************************"
echo "***Run End***"
date
echo "***************************************************************************************"
} 2>&1 | tee -a $log_file

if [ "$FINDER_PROCESS" != "" ]
then
	# Open the log file for all logged in users
    for pid_uid in $(ps -axo pid,uid,args | grep -i "[l]oginwindow.app" | awk '{print $1 "," $2}'); do
        pid=$(echo $pid_uid | cut -d, -f1)
        uid=$(echo $pid_uid | cut -d, -f2)
        # Replace echo with e.g. launchctl load.
        launchctl asuser "$uid" chroot -u "$uid" / open "$log_file"
    done
    	
fi