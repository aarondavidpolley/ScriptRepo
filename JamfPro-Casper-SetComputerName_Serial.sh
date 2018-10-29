#!/bin/bash

#Author: https://github.com/aarondavidpolley
#Purpose: automatically set a unique computer name using a prefix and serial number
#Feature: Supports script variable in Jamf Pro policy for $4 for Prefix override only
#Feature: Supports script variable in Jamf Pro policy for $5 for ComputerName override (ignore prefix)


#Check if prefix custom variable is empty
if [ -z $4 ]; then

#If empty, use this Prefix
Prefix="ACME-"

else

#If defined, use variable
Prefix="$4"

fi

#Find out serial
SerialNumber=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Serial Number (system)" | awk '{print $4}')

#Check if ComputerName custom variable is empty
if [ -z $5 ]; then

#If empty, use script logic for name
NewName="$Prefix$SerialNumber"

else

#If defined, use variable
NewName="$5"

fi

#Use Jamf Binary to set computername
/usr/local/jamf/bin/jamf setComputerName -name "$NewName"

#Report the name(s) that have been set#
ComputerName=$(/usr/sbin/scutil --get ComputerName)
HostName=$(/usr/sbin/scutil --get HostName)
LocalHostName=$(/usr/sbin/scutil --get LocalHostName)

echo "ComputerName: $ComputerName"
echo "HostName: $HostName"
echo "LocalHostName: $LocalHostName"