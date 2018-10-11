#!/bin/bash

#Author: https://github.com/aarondavidpolley
#Purpose: Request a computer asset number and then combines with prefix and room number to create and set Computer Name
#Feature: Supports script variable $4 to set the Prefix (without dash)
#Feature: Supports script variable $5 to set the room number

# Make sure we have an active desktop
dockStatus=$(pgrep -x Dock)
echo "Waiting for Desktop"
while [ "$dockStatus" == "" ]; do
  echo "Desktop is not loaded. Waiting."
  sleep 5
  dockStatus=$(pgrep -x Dock)
done

AssetNumRAW=$(/usr/bin/osascript << EOT

tell application "System Events"
    activate
set InputName to display dialog "Enter Asset Number of this Mac, i.e 09555" with icon caution default answer ""  buttons{"Continue"}
end tell
EOT
)

AssetNum=$(echo "$AssetNumRAW" | awk -F':' '{print $3}')


#Check if custom variable is empty
if [[ -z ${4+x} ]]; then

#If empty, use script logic for name
Prefix="M"

else

#If defined, use variable
Prefix="$4"

fi

#Check if custom variable is empty
if [[ -z ${5+x} ]]; then

#If empty, use script logic for name
RoomNum="0000"

else

#If defined, use variable
RoomNum="$5"

fi

NewName="$Prefix-$RoomNum-$AssetNum"

echo "$NewName"

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