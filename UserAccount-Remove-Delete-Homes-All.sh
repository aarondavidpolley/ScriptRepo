#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      2026-02-26                                                        #
# Version:   1.0                                                               #
# Purpose:   Purge local homes but skip if logged in						   #
################################################################################

#---Variables and such---#
script_version="1.0"
ADMINUSER="ladmin"
ADMINUSERID=$(id -u "$ADMINUSER")

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

#Periodically Delete user accounts that are not admin or logged in#

userList=$(find /Users -maxdepth 1 | tail -n -1 | grep -vw "Shared" | grep -vw ".localized" | grep -vw "$ADMINUSER" | grep -vw "$loggedInUser" | awk -F / '{print $3}')

echo "Deleting home directories for the following users..."

for a in $userList ; do
            echo "$a"
            rm -r /Users/"$a"  #delete the home directory
done