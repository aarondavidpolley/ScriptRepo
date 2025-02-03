#!/bin/sh

loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

/usr/sbin/dseditgroup -o edit -d "$loggedInUser" -t user admin