#!/bin/bash

  JAMF_PRO_URL="https://myorg.jamfcloud.com"
  JAMF_PRO_API_WRITE_USER="jssadmin"
  JAMF_PRO_API_WRITE_PASS="asdadasd"

listID=$(curl -k -s -H "Accept: application/xml" -u "${JAMF_PRO_API_WRITE_USER}":"${JAMF_PRO_API_WRITE_PASS}" "${JAMF_PRO_URL}/JSSResource/mobiledevices" | xmllint --format - | grep "<id>" | cut -d'>' -f2 | cut -d'<' -f1 | sort -h)

OLDIFS=$IFS
IFS=$'\n'       # make newlines the only separator
for ID in $listID; do
	
	## Upload the xml file
	echo "ID: $ID"
	curl -sfku "${JAMF_PRO_API_WRITE_USER}":"${JAMF_PRO_API_WRITE_PASS}" "${JAMF_PRO_URL}/JSSResource/mobiledevicecommands/command/UnmanageDevice/id/${ID}" -X POST
	printf "\n"
	
done
IFS=$OLDIFS

