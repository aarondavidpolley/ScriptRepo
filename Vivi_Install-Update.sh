#!/bin/sh

# Purpose: Script created to check the latest version of Vivi Desktop App (based on URL check), check the version installed, if any, and then download and install the latest if appropriate
# Note: this will backgrade to production version if a newer version (ie beta) has been installed
# Author: https://github.com/aarondavidpolley/
# Repo: https://github.com/aarondavidpolley/ScriptRepo/blob/master/Vivi_Install-Update.sh
viviURLmaster="https://api.vivi.io/mac"
viviURL=$(/usr/bin/curl -I "${viviURLmaster}" | grep -iw "Location" | cut -d':' -f2- | awk '{print $1}' | tr -d '\r')
viviDownload="${viviURL}"
viviVers=$(echo "${viviDownload}" | rev | cut -d '/' -f2 | rev)
viviPKG="Vivi-${viviVers}.pkg"

if [ -e "/Applications/Vivi.app/Contents/Info.plist" ]
then
	echo "Vivi is installed, checking version"
	viviVersLocal=$(defaults read "/Applications/Vivi.app/Contents/Info.plist" CFBundleShortVersionString)
	echo "Local version is ${viviVersLocal}"
else
	echo "Vivi is not installed in Applications folder"	
fi

echo "Latest Vivi version is ${viviVers}"

if [ -e "/Applications/Vivi.app/Contents/Info.plist" ]
then
	if [ "${viviVers}" = "${viviVersLocal}" ]
	then
		echo "Latest version is already installed, exiting"
		exit 0
	fi
fi

echo "Downloading latest vivi version"
/usr/bin/curl --location "${viviURL}" -o "/tmp/${viviPKG}"

/usr/sbin/installer -pkg "/tmp/${viviPKG}" -target /

if [ -e "/Applications/Vivi.app/Contents/Info.plist" ]
then
	viviVersLocal=$(defaults read "/Applications/Vivi.app/Contents/Info.plist" CFBundleShortVersionString)
	if [ "${viviVers}" !=  "${viviVersLocal}" ]
	then
		echo "Upgrade failed, exiting"
		exit 1
	fi
else
	echo "Install failed, exiting"
	exit 1
fi

echo "Removing tmp file /tmp/${viviPKG}"
rm -rf "/tmp/${viviPKG}"

exit 0