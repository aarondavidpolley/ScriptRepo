#!/bin/bash

#Author: https://github.com/aarondavidpolley
#Purpose: automatically set a unique computer name using a prefix and serial number
#Features: Supports script variable $1 to be passed at CLI
###Example: /path/to/script/ComputerName-Set-Serial.sh ComputerName

#Define a Prefix
Prefix="ACME-"

#Find out serial
SerialNumber=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Serial Number (system)" | awk '{print $4}')

#Check if custom variable is empty
if [[ -z ${1+x} ]]; then

#If empty, use script logic for name
NewName="$Prefix$SerialNumber"

else

#If defined, use variable
NewName="$1"

fi

#Use Scutil Binary to set computername
/usr/sbin/scutil --set ComputerName "$NewName"
/usr/sbin/scutil --set HostName "$NewName"
/usr/sbin/scutil --set LocalHostName "$NewName"

#Report the name(s) that have been set#
ComputerName=$(/usr/sbin/scutil --get ComputerName)
HostName=$(/usr/sbin/scutil --get HostName)
LocalHostName=$(/usr/sbin/scutil --get LocalHostName)

echo "ComputerName: $ComputerName"
echo "HostName: $HostName"
echo "LocalHostName: $LocalHostName"