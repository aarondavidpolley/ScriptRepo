#!/bin/sh

# Purpose: Script created to check the latest version of Microsoft Office (based on URL check), check the version installed, if any, and then download and install the latest if appropriate
# Note: this will backgrade to production version if a newer version (ie beta) has been installed
# Author: https://github.com/aarondavidpolley/
# Repo: https://github.com/aarondavidpolley/ScriptRepo/blob/master/Microsoft-Edge_Install-Update.sh
appURLmaster="https://go.microsoft.com/fwlink/?linkid=2069148"
appDownload=$(/usr/bin/curl -I "${appURLmaster}" | grep "Location" | cut -d':' -f2- | awk '{print $1}' | tr -d '\r')
appVers=$(echo "${appDownload}" | awk -F'-' '{print $NF}' | rev | cut -d'.' -f2- | rev)
appPKG=$(echo "${appDownload}" | awk -F'/' '{print $NF}')
appPLIST="/Applications/Microsoft Edge.app/Contents/Info.plist"
appNAME="Microsoft Edge"

if [ -e "${appPLIST}" ]
then
	echo "${appNAME} is installed, checking version"
	appVersLocal=$(defaults read "${appPLIST}" CFBundleShortVersionString)
	echo "Local version is ${appVersLocal}"
else
	echo "${appNAME} is not installed in Applications folder"	
fi

echo "Latest ${appNAME} version is ${appVers}"

if [ -e "${appPLIST}" ]
then
	if [ "${appVers}" = "${appVersLocal}" ]
	then
		echo "Latest version is already installed, exiting"
		exit 0
	fi
fi

echo "Downloading latest app version"
/usr/bin/curl --location "${appDownload}" -o "/tmp/${appPKG}"

/usr/sbin/installer -pkg "/tmp/${appPKG}" -target /

if [ -e "${appPLIST}" ]
then
	appVersLocal=$(defaults read "${appPLIST}" CFBundleShortVersionString)
	if [ "${appVers}" !=  "${appVersLocal}" ]
	then
		echo "Upgrade failed, exiting"
		exit 1
	fi
else
	echo "Install failed, exiting"
	exit 1
fi

echo "Removing tmp file /tmp/${appPKG}"
rm -rf "/tmp/${appPKG}"

exit 0