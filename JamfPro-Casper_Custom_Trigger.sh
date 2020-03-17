#!/bin/sh

#Designed to call custom triggers from other policies in Jamf Pro
#Call a single or set of custom triggers, helpful in deployments or for grouped self service policies

if [ ! -z "${4}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${4}"
fi

if [ ! -z "${5}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${5}"
fi

if [ ! -z "${6}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${6}"
fi

if [ ! -z "${7}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${7}"
fi

if [ ! -z "${8}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${8}"
fi

if [ ! -z "${9}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${9}"
fi

if [ ! -z "${10}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${10}"
fi

if [ ! -z "${11}" ]
then
	/usr/local/jamf/bin/jamf policy -trigger "${11}"
fi

exit 0