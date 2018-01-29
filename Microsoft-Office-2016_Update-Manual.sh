#!/bin/bash

UHOME="/Users/"
 # get list of all users
_USERS="$(dscl . list /Users | grep -v ^_.*)"
for u in $_USERS
do
   _dir="${UHOME}/${u}/Library/Preferences/"
   if [ -d "$_dir" ]
   then
       /usr/bin/defaults write "$_dir/com.microsoft.autoupdate2.plist" HowToCheck "Manual"
      chown $(id -un $u):$(id -gn $u) "$_dir/com.microsoft.autoupdate2.plist"
   fi
done

for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/com.microsoft.autoupdate2.plist HowToCheck "Manual"
  done