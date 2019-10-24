#!/bin/bash

#Firefox Scripted Update/install script
#Version: 1.1.0
#Modified: 2019-07-29

[ -f /tmp/debug ] && set -x
# This script downloads the latest Mozilla Firefox

ffv=$(defaults read /Applications/Firefox.app/Contents/Info.plist CFBundleShortVersionString)
set -- $ffv
ffvn=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')
echo "Installed Firefox version is $ffv"

# somehow find current version
curl -O FireFox*.dmg "https://download.mozilla.org/?product=firefox-latest&os=osx&lang=en-US" > /tmp/firefox.txt 2>/dev/null

# parse text file to find dmg file name and version
nffvf=$(grep dmg /tmp/firefox.txt | sed 's/.*href=\"\(.*.dmg\).>.*/\1/')
nffv=$(grep dmg /tmp/firefox.txt | sed 's/.*releases.\(.*\).mac.*/\1/')

echo "Latest Firefox version is $nffv"


if [ "$ffv" == "$nffv" ]
then

	echo "Current version is $ffv and latest version is $nffv so no update was performed"
	
	exit 0

fi

echo Updating Firefox to $nffv from $ffv

URL="$nffvf"
#just the file name
dmgfile="${URL##*/}"
dmgFilePath="/tmp/${dmgfile}"
# Use mktemp to specify a mountpoint for the disk image (XXXX generates numbers)
TMPMOUNT=$(/usr/bin/mktemp -d /tmp/firefox.XXXX)

/bin/echo "Downloading Firefox"
/usr/bin/curl -s -o "$dmgFilePath" ${URL}
echo "Mounting $dmgFilePath to $TMPMOUNT"
# Mount the latest Firefox disk image to /tmp/firefox.XXXX mountpoint
hdiutil attach "$dmgFilePath" -mountpoint "$TMPMOUNT" -nobrowse -noverify -noautoopen -quiet

#verify it is in the dmg first
if [ -e "$TMPMOUNT/Firefox.app" ]; then

	#Check installed versionFirefox.app
	CurrentVersion=$(/usr/bin/defaults read /Applications/Firefox.app/Contents/Info.plist CFBundleShortVersionString)
	NewVersion=$(/usr/bin/defaults read $TMPMOUNT/Firefox.app/Contents/Info.plist CFBundleShortVersionString)

	echo "Current Version $CurrentVersion"
	echo "New Version $NewVersion"

	if [ "$CurrentVersion" != "$NewVersion" ]
	then
	
		APP_PROCESS=$(pgrep -l "firefox")
		FINDER_PROCESS=$(pgrep -l "Finder")
		
		if [ "$FINDER_PROCESS" != "" ] && [ "$APP_PROCESS" != "" ]
		then
			echo "Quitting app to update and telling user"
			/usr/local/bin/jamf displayMessage -message "We are updating Mozilla Firefox, please wait to re-open."
			processes=$(ps aux | grep "Firefox.app" | grep -v grep | grep "$ffvn "| awk '{print $2}')
			for i in $processes; do kill $i; done
			
		fi
		
		
		/bin/echo "Installing..."
		#install new version
		cp -R "$TMPMOUNT/Firefox.app" "/Applications/"
		chmod -R 755 /Applications/Firefox.app
		chown -R root:wheel /Applications/Firefox.app 
		
		
		if [ "$FINDER_PROCESS" != "" ] && [ "$APP_PROCESS" != "" ]
		then
			#Tell user it has been updated & re-open it
			echo "Telling the user we have updated Firefox to latest version and re-opening app"
			/usr/local/bin/jamf displayMessage -message "We have installed the latest version of Mozilla Firefox: $NewVersion"
			open /Applications/Firefox.app
		fi

	else
	
		echo "Versions are the same"
	
	fi
fi

# Clean-up
echo "Cleaning Up..."
# Unmount the Firefox disk image from /tmp/firefox.XXXX
echo "Un-mounting $TMPMOUNT"
/usr/bin/hdiutil detach "$TMPMOUNT" -quiet
sleep 3
if [ -d "$TMPMOUNT" ]
then
	/bin/rmdir "$TMPMOUNT"
fi

# Remove the /tmp/firefox.XXXX mountpoint

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

echo "Removing temp txt file"
rm /tmp/firefox.txt

exit 0