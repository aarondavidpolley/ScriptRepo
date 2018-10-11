#!/bin/bash

#Author: https://github.com/aarondavidpolley
#Purpose: Request and set computer name

# Make sure we have an active desktop
dockStatus=$(pgrep -x Dock)
echo "Waiting for Desktop"
while [ "$dockStatus" == "" ]; do
  echo "Desktop is not loaded. Waiting."
  sleep 5
  dockStatus=$(pgrep -x Dock)
done

NewNameRAW=$(/usr/bin/osascript << EOT

tell application "System Events"
    activate
set InputName to display dialog "Enter the computer name of this Mac, i.e MAC123456" with icon caution default answer ""  buttons{"Continue"}
end tell
EOT
)

NewName="$NewNameRAW"

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