#!/bin/bash

#####################################################
#Script for copying files to existing User homes    #
#####################################################

#####################################################
#Install the file to /tmp & specify the file details#
#####################################################
#Edit Below#                                        #
#####################################################

#Folder containing User Folders#
#System Default below#
UHOME="/Users/"

#Name of file - including extension#
FILE="com.github.aarondavidpolley.plist"

#Desired Subfolder to copy file in the User Folders - i.e. What comes after /Users/<username>#
SUBFOLDER="/Library/Preferences/"

#Folder to copy the file from#
TMPFOLDER="/tmp/"

#####################################################
#DON't EDIT AFTER THIS LINE                         #
#####################################################


COPYPATH="${TMPFOLDER}${FILE}"

 # get list of all users
_USERS="$(dscl . list /Users | grep -v ^_.*)"
for u in $_USERS
do
   _dir="${UHOME}/${u}${SUBFOLDER}"
   if [ -d "$_dir" ]
   then
       /bin/cp "$COPYPATH" "$_dir"
      chown $(id -un $u):$(id -gn $u) "$_dir${FILE}"
   fi
done
