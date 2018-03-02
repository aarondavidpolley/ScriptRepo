#!/bin/bash

################################################################################
# Author:    Aaron Polley                                                      #
# Date:      29/11/2017                                                        #
# Version:   0.1                                                               #
# Purpose:   Use brute force to logout current user(s)                         #
################################################################################

#---Variables and such---#
script_version="0.1"
user_id=`id -u`
user_name=`id -un $user_id`

    # Run command for all logged in users.
    for pid_uid in $(ps -axo pid,uid,args | grep -i "[l]oginwindow.app" | awk '{print $1 "," $2}'); do
        pid=$(echo $pid_uid | cut -d, -f1)
        uid=$(echo $pid_uid | cut -d, -f2)
        # Per User Actions
        launchctl asuser "$uid" chroot -u "$uid" / launchctl bootout user/$(id -u $uid)
    done

exit 0