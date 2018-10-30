#!/bin/bash

# Designed for use as a Jamf Pro Extension Attribute
# Gathers Microsoft System Center Endpoint Protection Data

LABEL="RTPStatistics"

BINARY="/Applications/System Center Endpoint Protection.app/Contents/MacOS/scep_daemon"

if [ -e "$BINARY" ]
then
    RESULT=$(/Applications/System\ Center\ Endpoint\ Protection.app/Contents/MacOS/scep_daemon --status | grep "$LABEL" | cut -d'=' -f2)
    echo "<result>$RESULT</result>"
else
    echo "<result>Not Installed</result>"
fi

exit 0