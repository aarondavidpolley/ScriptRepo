#!/bin/sh

# Purpose: Script created to check the latest version of Zoom Outlook Plugin (based on URL check), check the version installed, if any, and then download and install the latest if appropriate
# Note: this will backgrade to production version if a newer version (ie beta) has been installed
# Author: https://github.com/aarondavidpolley/
# Repo: https://github.com/aarondavidpolley/ScriptRepo/blob/master/Zoom_Install-Update.sh

zoomURL="https://zoom.us/client/latest/ZoomMacOutlookPlugin.pkg"
zoomDownload=$(/usr/bin/curl -I "${zoomURL}" | grep "location" | cut -d':' -f2- | awk '{print $1}')
zoomVers=$(echo "${zoomDownload}" | rev | cut -d'/' -f2- | cut -d'/' -f1 | cut -d'.' -f2- | rev)
zoomPKG="ZoomMacOutlookPlugin-${zoomVers}.pkg"

if [ -e /Applications/ZoomOutlookPlugin/PluginLauncher.app/Contents/Info.plist ]
then
	echo "Zoom Outlook Plugin is not installed, checking version"
	zoomVersLocal=$(defaults read /Applications/ZoomOutlookPlugin/PluginLauncher.app/Contents/Info.plist CFBundleShortVersionString)
	echo "Zoom Outlook Plugin local version is ${zoomVersLocal}"
else
	echo "Zoom Outlook Plugin is not installed in Applications folder"	
fi

echo "Latest Zoom Outlook Plugin version is ${zoomVers}"

if [ -e /Applications/ZoomOutlookPlugin/PluginLauncher.app/Contents/Info.plist ]
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

if [ -e /Applications/ZoomOutlookPlugin/PluginLauncher.app/Contents/Info.plist ]
then
	zoomVersLocal=$(defaults read /Applications/ZoomOutlookPlugin/PluginLauncher.app/Contents/Info.plist CFBundleShortVersionString)
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