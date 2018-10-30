#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      29/10/2018                                                        #
# Version:   1.0                                                               #
# Purpose:   Use launchctl to logout current users and purge local accounts    #
################################################################################

#---Variables and such---#
script_version="1.0"
ADMINUSER="ladmin"
ADMINUSERID=$(id -u "$ADMINUSER")

# Bootout all users except admin
    for pid_uid in $(ps -axo pid,uid,args | grep -i "[l]oginwindow.app" | grep -v $ADMINUSERID | awk '{print $1 "," $2}'); do
        pid=$(echo $pid_uid | cut -d, -f1)
        uid=$(echo $pid_uid | cut -d, -f2)
        # Per User Actions
        launchctl asuser "$uid" chroot -u "$uid" / launchctl bootout user/$(id -u $uid)
    done

sleep 3

#Periodically Delete user accounts that are not admin#

userList=$(/usr/bin/dscl . -list /Users UniqueID | grep -Ev "^_|com.*|root|nobody|daemon|\/" | grep -vw "$ADMINUSER" | awk '{print $1}')

echo "Deleting account and home directory for the following users..."

for a in $userList ; do
            echo "$a"
            dscl . delete /Users/"$a"  #delete the account
            rm -r /Users/"$a"  #delete the home directory
done