#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      2026-02-26                                                        #
# Version:   1.0                                                               #
# Purpose:   Purge local accounts but skip if logged in						   #
################################################################################

#---Variables and such---#
script_version="1.0"
ADMINUSER="ladmin"
ADMINUSERID=$(id -u "$ADMINUSER")

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

#Periodically Delete user accounts that are not admin or logged in#

userList=$(/usr/bin/dscl . -list /Users UniqueID | grep -Ev "^_|com.*|root|nobody|daemon|\/" | grep -vw "$ADMINUSER" | grep -vw "$loggedInUser" | awk '{print $1}')

echo "Deleting accounts for the following users..."

for a in $userList ; do
            echo "$a"
            dscl . delete /Users/"$a"  #delete the account
done