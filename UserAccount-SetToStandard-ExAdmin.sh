#!/bin/sh

ADMINUSER="ladmin"

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

if [ "$ADMINUSER" = "$loggedInUser" ]
then

	echo "$loggedInUser needs to stay as admin, exiting..."
	exit 0
	
else

	/usr/sbin/dseditgroup -o edit -d "$loggedInUser" -t user admin

fi