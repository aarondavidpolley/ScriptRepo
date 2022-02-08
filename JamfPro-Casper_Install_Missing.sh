#!/bin/sh

#Designed to call custom triggers from other policies in Jamf Pro
#Call a set of custom triggers, helpful in deployments or for grouped self service policies

if [ ! -z "${4}" ]
then
	echo "Asset 1 path is ${4}"
	
	if [ ! -e "${4}" ]
	then
		
		echo "${4} doesn't exist, looking for policy trigger"
		
		if [ ! -z "${5}" ]
		then
			echo "Calling policy trigger ${5}"
			/usr/local/jamf/bin/jamf policy -trigger "${5}"
		else
			echo "ERROR: missing policy trigger for Asset 1, unable to install"
		fi
	
	else
		echo "Asset 1 path ${4} already exists, skipping install"
	fi

fi

if [ ! -z "${6}" ]
then
	echo "Asset 2 path is ${6}"
	
	if [ ! -e "${6}" ]
	then
		
		echo "${6} doesn't exist, looking for policy trigger"
		
		if [ ! -z "${7}" ]
		then
			echo "Calling policy trigger ${7}"
			/usr/local/jamf/bin/jamf policy -trigger "${7}"
		else
			echo "ERROR: missing policy trigger for Asset 2, unable to install"
		fi
	
	else
		echo "Asset 2 path ${6} already exists, skipping install"
	fi

fi

if [ ! -z "${8}" ]
then
	echo "Asset 3 path is ${8}"
	
	if [ ! -e "${8}" ]
	then
		
		echo "${8} doesn't exist, looking for policy trigger"
		
		if [ ! -z "${9}" ]
		then
			echo "Calling policy trigger ${9}"
			/usr/local/jamf/bin/jamf policy -trigger "${9}"
		else
			echo "ERROR: missing policy trigger for Asset 3, unable to install"
		fi
	
	else
		echo "Asset 3 path ${8} already exists, skipping install"
	fi

fi

if [ ! -z "${10}" ]
then
	echo "Asset 4 path is ${10}"
	
	if [ ! -e "${10}" ]
	then
		
		echo "${10} doesn't exist, looking for policy trigger"
		
		if [ ! -z "${11}" ]
		then
			echo "Calling policy trigger ${11}"
			/usr/local/jamf/bin/jamf policy -trigger "${11}"
		else
			echo "ERROR: missing policy trigger for Asset 4, unable to install"
		fi
	
	else
		echo "Asset 4 path ${10} already exists, skipping install"
	fi

fi