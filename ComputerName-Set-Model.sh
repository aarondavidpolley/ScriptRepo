#!/bin/bash

#Author: https://github.com/aarondavidpolley
#Purpose: automatically set a unique computer name using model

MyModel=$(system_profiler SPHardwareDataType | grep "Model Name" | awk -F':' '{print $2}' | awk '{gsub(/^ +| +$/,"")} {print}')

NewName=$(echo ${MyModel// /-})

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