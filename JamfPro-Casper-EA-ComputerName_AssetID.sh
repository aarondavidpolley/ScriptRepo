#!/bin/sh

#Purpose - Jamf Pro EA to check if Computer Name matches ASSET ID

## API READ ONLY user info for Jamf Pro. Please specify
apiuser="apiuser"
apipass="apipass"

## Local Copy of ASSET ID
Asset_PATH="/Library/Application Support/JAMF/assetid"

#Have we checked this before#
if [ -e "${Asset_PATH}" ]
then
	Local_Asset_Tag=$(head -n 1 "${Asset_PATH}")
fi

if [ -z "${Local_Asset_Tag}" ]
then

	## Grab Jamf Pro URL
	jssurl=$(defaults read /Library/Preferences/com.jamfsoftware.jamf.plist jss_url | sed 's:/*$::')

	## Get the computer's serial number (for locating the record in the API)
	Serial_Num=$(ioreg -rd1 -c IOPlatformExpertDevice | awk -F'"' '/IOPlatformSerialNumber/{print $4}')
	
	if [ -z "${Serial_Num}" ]
	then
		echo "<result>SERIAL NUMBER ERROR</result>"
		exit 1
	fi
	
	## Generate variable containing "location" information on the computer record
	Comp_Location_Data_RAW=$(curl -H "Accept: text/xml" -isku "${apiuser}:${apipass}" "${jssurl}/JSSResource/computers/serialnumber/${Serial_Num}/subset/general")
	
	## Check API Call
	API_CHECK=$(echo "${Comp_Location_Data_RAW}" | head -n 1 | cut -d' ' -f2 | awk '{print $1}' 2>/dev/null)
	
	if [ "${API_CHECK}" = "401" ]
	then
		echo "<result>BAD API USER</result>"
		exit 1
	fi
	
	if [ "${API_CHECK}" != "200" ]
	then
		echo "<result>BAD API CALL</result>"
		exit 1
	fi
	
	Comp_Location_Data=$(echo "${Comp_Location_Data_RAW}" | grep "<?xml" | xmllint --format - 2>/dev/null)
		
	
	## Extract items from the above variable
	Asset_Tag=$(echo "${Comp_Location_Data}" | awk -F'>|<' '/<asset_tag/{print $3}' 2>/dev/null)
	echo "${Asset_Tag}" > "${Asset_PATH}"

else
	
	#Use existing value#
	Asset_Tag="${Local_Asset_Tag}"

fi

if [ -z "${Asset_Tag}" ]
then
	echo "<result>NO ASSET TAG</result>"
	exit 1
fi

Computer_Name=$(/usr/local/bin/jamf getComputerName | awk -F'>|<' '/<computer_name/{print $3}' 2>/dev/null)


if [ -z "${Computer_Name}" ]
then
	echo "<result>COMPUTER NAME ERROR</result>"
	exit 1
fi

## Print back what was found

if [ "${Asset_Tag}" = "${Computer_Name}" ]
then
	echo "<result>True</result>"
else
	echo "<result>False</result>"
fi
