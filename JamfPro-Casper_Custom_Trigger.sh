#!/bin/sh

#Designed to call custom triggers from other policies in Jamf Pro
#Make sure to label Variable 4 in Jamf Pro as "Custom Trigger"

/usr/local/jamf/bin/jamf policy -trigger "${4}"