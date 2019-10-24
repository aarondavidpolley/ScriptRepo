#!/bin/bash

################################################################################
#---Script Details---#
################################################################################
script_name=$(basename "${0}")
script_version="1.0"
script_author="https://github.com/aarondavidpolley"
script_author_org="http://compnow.com.au"
script_date="2019-09-30"
script_description="Set Authbind for Jamf Pro 10.14.0 and above"
################################################################################

################################################################################
#---Variables---#
################################################################################
SAFETY="${1}"
JamfVersion="${2}"
DEBUG="${3}"
WHOAREYOU=$(whoami)
KERNEL=$(uname)
DISTRO=$(cat /etc/*-release | grep PRETTY_NAME | awk -F"\"" '{print $2}' | awk '{print $1}')
HOST=$(hostname)
DATE=$(date "+%Y-%m-%d")
DATETIME=$(date '+%Y-%m-%d_%H-%M-%S')

################################################################################
#---Help Page---#
################################################################################

if [ "${SAFETY}" != "SAFETY_OFF" ] && [ "${SAFETY}" != "SAFETY_ON" ]; then

echo "************************************************"
echo "You have run this script without setting an expected mode"
echo "Run this script with either:"
echo "sudo $script_name SAFETY_ON"
echo "or"
echo "sudo $script_name SAFETY_OFF"
echo "************************************************"

exit 1

fi

################################################################################
#---Pre Run Checks---#
################################################################################

#---OS Check--#
if [ "$KERNEL" != "Linux" ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: Only Ubuntu Linux is currently supported, exiting..."
	exit 1
fi

if [ "$DISTRO" != "Ubuntu" ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: Only Ubuntu Linux is currently supported, exiting..."
	exit 1
fi

#--SAFETY CHECK--#
if [ "${SAFETY}" == "SAFETY_OFF" ]; then

TEST_MODE=false

fi 

if [ "${SAFETY}" == "SAFETY_ON" ]; then

TEST_MODE=true

fi 


#---User Check--#
if [ "$WHOAREYOU" != "root" ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: You need to run with sudo/root privileges, exiting..."
	exit 1
fi

#---Required Componenets Check---#

#apt#
if [ ! -e /etc/systemd/system/jamf.tomcat8.service ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: Jamf Pro tomcat service config file is required for this tool and not found, exiting"
	echo "$(date '+%Y-%m-%d_%H-%M-%S') MISSING: /etc/systemd/system/jamf.tomcat8.service"
	exit 1
fi

################################################################################
#---Configure Logging---#
################################################################################

#---Define Log File---#
log_file="/var/log/${script_name}_${HOST}_${DATE}.log"

#---Create Log File---#
if [ ! -e "$log_file" ]
then
	touch "$log_file"
fi

#---Set log file permissions---#
chmod 777 "$log_file"

#---Start Logging---#
echo "$(date '+%Y-%m-%d_%H-%M-%S') NOTICE: Logging to $log_file"

#exec >> "$log_file" 2>&1
{


################################################################################
#---Start Script Tasks---#
################################################################################

if [ $TEST_MODE = true ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') START TEST RUN: Starting ${script_name} on ${HOST}"
fi

if [ $TEST_MODE = false ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') START RUN: Starting ${script_name} on ${HOST}"
fi

CHECK_AUTHBIND=$(cat /etc/systemd/system/jamf.tomcat8.service | grep "ExecStart" | awk -F "/" '{print $4}' | awk '{print $1}' | head -n 1)

if [ "${SAFETY}" == "SAFETY_ON" ]; then
	#add authbind to init.d for tomcat servers on port 443
	echo "Adding Authbind to Jamf Tomcat"
	if [ "$CHECK_AUTHBIND" == "authbind" ]
	then
		echo "NOTE: AUTHBIND already set, skipping"
	else
		cat <<EOF
COMMAND: sed -i 's#ExecStart=#ExecStart=/usr/bin/authbind --deep #g' /etc/systemd/system/jamf.tomcat8.service
	sleep 2
	systemctl daemon-reload
EOF
	fi

else

	#add authbind to init.d for tomcat servers on port 443
	echo "Adding Authbind to Jamf Tomcat"
	if [ "$CHECK_AUTHBIND" == "authbind" ]
	then
		echo "NOTE: AUTHBIND already set, skipping"
	else
		sed -i 's#ExecStart=#ExecStart=/usr/bin/authbind --deep #g' /etc/systemd/system/jamf.tomcat8.service
		sleep 2
		systemctl daemon-reload
	fi

fi

echo "$(date '+%Y-%m-%d_%H-%M-%S') NOTICE: Please restart the tomcat service for changes to take effect"
echo "$(date '+%Y-%m-%d_%H-%M-%S') COMMAND: service jamf.tomcat8 restart"

if [ $TEST_MODE = true ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') END TEST RUN: Finished ${script_name} on ${HOST}"
fi

if [ $TEST_MODE = false ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') END RUN: Finished ${script_name} on ${HOST}"
fi


} 2>&1 | tee -a "$log_file"

exit 0