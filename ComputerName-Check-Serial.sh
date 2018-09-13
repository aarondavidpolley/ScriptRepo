#!/bin/bash

#Author: https://github.com/aarondavidpolley
#Purpose: act as install check script for https://github.com/aarondavidpolley/ScriptRepo/blob/master/ComputerName-Set-Serial.sh
#Features: Supports script variable $1 to be passed at CLI
###Example: /path/to/script/ComputerName-Check-Serial.sh ComputerName

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

#Report the name(s) that have been set#
ComputerName=$(/usr/sbin/scutil --get ComputerName)
HostName=$(/usr/sbin/scutil --get HostName)
LocalHostName=$(/usr/sbin/scutil --get LocalHostName)

if [[ "$NewName" != "$ComputerName" ]]; then

echo "Computername is not $NewName - time to change"
echo "ComputerName: $ComputerName"
echo "HostName: $HostName"
echo "LocalHostName: $LocalHostName"

exit 0

fi

if [[ "$NewName" != "$HostName" ]]; then

echo "HostName is not $NewName - time to change"
echo "ComputerName: $ComputerName"
echo "HostName: $HostName"
echo "LocalHostName: $LocalHostName"

exit 0

fi

if [[ "$NewName" != "$LocalHostName" ]]; then

echo "LocalHostName is not $NewName - time to change"
echo "ComputerName: $ComputerName"
echo "HostName: $HostName"
echo "LocalHostName: $LocalHostName"

exit 0

fi

exit 1