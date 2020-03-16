#!/bin/sh

#Purpose - Jamf Pro EA to check if firmware password is set
#Source - https://github.com/aarondavidpolley/ScriptRepo/blob/master/JamfPro-Casper-EA-Firmware_Password_Status.sh

WHOAREYOU=$(whoami)

if [ "$WHOAREYOU" != "root" ]
then
	echo "<result>SCRIPT ERROR - Not Root</result>"
	exit 1
fi

if [ ! -e /usr/sbin/firmwarepasswd ]
then
	echo "<result>SCRIPT ERROR - Binary Missing</result>"
	exit 1
fi

Firmware_Pass_Status=$(/usr/sbin/firmwarepasswd -check | cut -d":" -f2- | cut -d" " -f2- 2>/dev/null)


if [ -z "${Firmware_Pass_Status}" ]
then
	echo "<result>SCRIPT ERROR - Empty Output</result>"
	exit 1
else
	echo "<result>${Firmware_Pass_Status}</result>"
	exit 0
fi
