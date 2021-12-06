#!/bin/bash

# Script Variable
Var4="${4}"

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

if [ -n "${Var4}" ]
then
	UserName="${Var4}"
else
	UserName="${loggedInUser}"
fi

echo "Adding ${UserName} to admin group"

/usr/sbin/dseditgroup -o edit -a "${UserName}" -t user admin

exit 0