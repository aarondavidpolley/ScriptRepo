#!/bin/sh

# Purpose: Script created to check the latest version of Skype for Business Desktop App (based on URL check), check the version installed, if any, and then download and install the latest if appropriate
# Note: this will backgrade to production version if a newer version (ie beta) has been installed
# Author: https://github.com/aarondavidpolley/
# Repo: https://github.com/aarondavidpolley/ScriptRepo/blob/master/SkypeForBusiness_Install-Update.sh
sfbURLmaster="https://go.microsoft.com/fwlink/?linkid=832978"
sfbURL=$(/usr/bin/curl -I "${sfbURLmaster}" | grep "Location" | cut -d':' -f2- | awk '{print $1}' | tr -d '\r')
sfbDownload=$(/usr/bin/curl -I "${sfbURL}" | grep "Location" | cut -d':' -f2- | awk '{print $1}' | tr -d '\r')
sfbVers=$(echo "${sfbDownload}" | rev | cut -d'.' -f2- | cut -d'-' -f1 | rev | cut -d'.' -f1,2)
sfbPKG="SkypeForBusinessInstaller-${sfbVers}.pkg"

if [ -e "/Applications/Skype for Business.app/Contents/Info.plist" ]
then
	echo "Skype for Business is installed, checking version"
	sfbVersLocal=$(defaults read "/Applications/Skype for Business.app/Contents/Info.plist" CFBundleShortVersionString | cut -d'.' -f1,2)
	echo "Local version is ${sfbVersLocal}"
else
	echo "Skype for Business is not installed in Applications folder"	
fi

echo "Latest Skype for Business version is ${sfbVers}"

if [ -e "/Applications/Skype for Business.app/Contents/Info.plist" ]
then
	if [ "${sfbVers}" = "${sfbVersLocal}" ]
	then
		echo "Latest version is already installed, exiting"
		exit 0
	fi
fi

echo "Downloading latest sfb version"
/usr/bin/curl --location "${sfbURL}" -o "/tmp/${sfbPKG}"

/usr/sbin/installer -pkg "/tmp/${sfbPKG}" -target /

if [ -e "/Applications/Skype for Business.app/Contents/Info.plist" ]
then
	sfbVersLocal=$(defaults read "/Applications/Skype for Business.app/Contents/Info.plist" CFBundleShortVersionString | cut -d'.' -f1,2)
	if [ "${sfbVers}" !=  "${sfbVersLocal}" ]
	then
		echo "Upgrade failed, exiting"
		exit 1
	fi
else
	echo "Install failed, exiting"
	exit 1
fi

echo "Removing tmp file /tmp/${sfbPKG}"
rm -rf "/tmp/${sfbPKG}"

exit 0