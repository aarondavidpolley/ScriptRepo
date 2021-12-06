#!/bin/bash

#Google Chrome Scripted Update/install script
#Version: 1.1.1
#Modified: 2021-07-19 for universal binary URL


[ -f /tmp/debug ] && set -x
# This script downloads the latest Google Chrome

URL='https://dl.google.com/chrome/mac/universal/stable/GGRO/googlechrome.dmg'
#just the file name
dmgfile="${URL##*/}"
dmgFilePath="/tmp/${dmgfile}"
# Use mktemp to specify a mountpoint for the disk image (XXXX generates numbers)
TMPMOUNT=$(/usr/bin/mktemp -d /tmp/chrome.XXXX)

/bin/echo "Downloading Chrome"
/usr/bin/curl -s -o "$dmgFilePath" ${URL}
echo "Mounting $dmgFilePath to $TMPMOUNT"
# Mount the latest Chrome disk image to /tmp/googlechrome.XXXX mountpoint
hdiutil attach "$dmgFilePath" -mountpoint "$TMPMOUNT" -nobrowse -noverify -noautoopen -quiet

#verify it is in the dmg first
if [ -e "$TMPMOUNT/Google Chrome.app" ]; then

	#Check installed version
	CurrentVersion=$(/usr/bin/defaults read /Applications/Google\ Chrome.app/Contents/Info.plist CFBundleShortVersionString)
	NewVersion=$(/usr/bin/defaults read $TMPMOUNT/Google\ Chrome.app/Contents/Info.plist CFBundleShortVersionString)

	echo "Current Version $CurrentVersion"
	echo "New Version $NewVersion"

	if [ "$CurrentVersion" != "$NewVersion" ]
	then
	
		CHROME_PROCESS=$(pgrep -l "Google Chrome")
		FINDER_PROCESS=$(pgrep -l "Finder")
		
		if [ "$FINDER_PROCESS" != "" ] && [ "$CHROME_PROCESS" != "" ]
		then
			echo "Quitting app to update and telling user"
			/usr/local/bin/jamf displayMessage -message "We are updating Google Chrome, please wait to re-open."
			processes=$(ps aux | grep "Google Chrome.app" | grep -v grep | grep "$ffvn "| awk '{print $2}')
			for i in $processes; do kill $i; done
			
		fi

		if [ -e "/Applications/Google Chrome.app" ]
		then
			/bin/echo "Removing old copy..."
			#Finder did not pick up on the new version this should force launchservices to notice
			rm -rf "/Applications/Google Chrome.app"
		fi
		
		
		/bin/echo "Installing..."
		ditto -rsrc "$TMPMOUNT/Google Chrome.app" "/Applications/Google Chrome.app"
		
		
		if [ "$FINDER_PROCESS" != "" ] && [ "$CHROME_PROCESS" != "" ]
		then
			#Tell user it has been updated & re-open it
			echo "Telling the user we have updated Chrome to latest version and re-opening app"
			/usr/local/bin/jamf displayMessage -message "We have installed the latest version of Google Chrome: $NewVersion"
			open /Applications/Google\ Chrome.app
		fi

	else
	
		echo "Versions are the same"
	
	fi
fi

# Clean-up
echo "Cleaning Up..."
# Unmount the Chrome disk image from /tmp/googlechrome.XXXX
echo "Un-mounting $TMPMOUNT"
/usr/bin/hdiutil detach "$TMPMOUNT" -quiet
sleep 3
if [ -d "$TMPMOUNT" ]
then
	/bin/rmdir "$TMPMOUNT"
fi

# Remove the /tmp/googlechrome.XXXX mountpoint

if [ -e "$TMPMOUNT" ]
then
	echo "$TMPMOUNT still there, forcing un mount"
	umount -f "$TMPMOUNT"
	sleep 3
fi

if [ -d "$TMPMOUNT" ]
then
	echo "$TMPMOUNT directory still there, removing if empty"
	/bin/rmdir "$TMPMOUNT"
fi

if [ -e "$TMPMOUNT" ]
then
	echo "ERROR: $TMPMOUNT still exists, manual cleanup required"
fi

# Remove the downloaded disk image
echo "Removing disk image $dmgFilePath"
/bin/rm -rf "$dmgFilePath"

exit 0