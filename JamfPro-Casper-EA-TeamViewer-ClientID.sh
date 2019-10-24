#!/bin/bash


if [ -e /Library/Preferences/com.teamviewer.teamviewer.preferences.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer.preferences.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.teamviewer13.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer13.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.teamviewer12.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer12.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.teamviewer11.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer11.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.teamviewer10.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer10.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.teamviewer9.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer9.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.teamviewer8.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.teamviewer8.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.TeamViewer8.Settings.plist ]
then
	ID=$(defaults read /Library/Preferences/com.TeamViewer8.Settings.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.TeamViewerHost.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.TeamViewerHost.plist ClientID)
    echo "<result>${ID}</result>"
elif [ -e /Library/Preferences/com.teamviewer.TeamViewer.plist ]
then
	ID=$(defaults read /Library/Preferences/com.teamviewer.TeamViewer.plist ClientID)
    echo "<result>${ID}</result>"
else
    echo "<result>No Preference File</result>"
fi	