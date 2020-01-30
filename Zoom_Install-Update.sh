#!/bin/sh

# Purpose: Script created to check the latest version (based on URL check), check the version installed, if any, and then download and install the latest if appropriate
# Note: this will backgrade to production version if a newer version (ie beta) has been installed
# Author: https://github.com/aarondavidpolley/
# Repo: https://github.com/aarondavidpolley/ScriptRepo/blob/master/Zoom_Install-Update.sh

zoomURL="https://zoom.us/client/latest/Zoom.pkg"
zoomDownload=$(/usr/bin/curl -I "${zoomURL}" | grep "location" | cut -d':' -f2- | awk '{print $1}')
zoomVers=$(echo "${zoomDownload}" | rev | cut -d'/' -f2- | cut -d'/' -f1 | rev)
zoomPKG="Zoom-${zoomVers}.pkg"

if [ -e /Applications/zoom.us.app/Contents/Info.plist ]
then
	echo "Zoom is installed, checking version"
	zoomVersLocal=$(defaults read /Applications/zoom.us.app/Contents/Info.plist CFBundleVersion)
	echo "Local version is ${zoomVersLocal}"
else
	echo "Zoom is not installed in Applications folder"	
fi

echo "Latest Zoom version is ${zoomVers}"

if [ -e /Applications/zoom.us.app/Contents/Info.plist ]
then
	if [ "${zoomVers}" = "${zoomVersLocal}" ]
	then
		echo "Latest version is already installed, exiting"
		exit 0
	fi
fi

echo "Downloading latest zoom version"
/usr/bin/curl --location "${zoomURL}" -o "/tmp/${zoomPKG}"

/usr/sbin/installer -pkg "/tmp/${zoomPKG}" -target /

if [ -e /Applications/zoom.us.app/Contents/Info.plist ]
then
	zoomVersLocal=$(defaults read /Applications/zoom.us.app/Contents/Info.plist CFBundleVersion)
	if [ "${zoomVers}" !=  "${zoomVersLocal}" ]
	then
		echo "Upgrade failed, exiting"
		exit 1
	fi
else
	echo "Install failed, exiting"
	exit 1
fi

echo "Removing tmp file /tmp/${zoomPKG}"
rm -rf "/tmp/${zoomPKG}"

exit 0