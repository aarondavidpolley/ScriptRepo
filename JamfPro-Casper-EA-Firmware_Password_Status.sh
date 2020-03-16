#!/bin/sh

#Purpose - Jamf Pro EA to check if firmware password is set

WHOAREYOU=$(whoami)

if [ "$WHOAREYOU" != "root" ]
then
	echo "<result>SCRIPT ERROR</result>"
	exit 1
fi

Firmware_Pass_Status=$(/usr/sbin/firmwarepasswd -check | cut -d":" -f2- | cut -d" " -f2- 2>/dev/null)


if [ -z "${Firmware_Pass_Status}" ]
then
	echo "<result>SCRIPT ERROR</result>"
	exit 1
else
	echo "<result>${Firmware_Pass_Status}</result>"
	exit 0
fi
