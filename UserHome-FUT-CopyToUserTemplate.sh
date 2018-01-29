#!/bin/bash

#####################################################
#Script for copying files to User Templates.        #
#####################################################

#####################################################
#Install the file to /tmp & specify the file details#
#####################################################
#Edit Below#                                        #
#####################################################

#Name of file - including extension#
FILE="com.github.aarondavidpolley.plist"

#Desired Subfolder to copy file in the User Template Folders - i.e. What comes after /Users/<username> when created#
SUBFOLDER="/Library/Preferences/"

#Folder to copy the file from#
TMPFOLDER="/tmp/"

#####################################################
#DON't EDIT AFTER THIS LINE                         #
#####################################################


COPYPATH="${TMPFOLDER}${FILE}"


for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    cp "${COPYPATH}" "${USER_TEMPLATE}${SUBFOLDER}"
  done


