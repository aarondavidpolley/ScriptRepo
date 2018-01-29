#!/bin/bash

UHOME="/Users/"
FILE="/Library/Preferences/com.squirrels.Reflection.plist"
 # get list of all users
_USERS="$(dscl . list /Users | grep -v ^_.*)"
for u in $_USERS
do
   _dir="${UHOME}/${u}/Library/Preferences/"
   if [ -d "$_dir" ]
   then
       /bin/cp "$FILE" "$_dir"
      chown $(id -un $u):$(id -gn $u) "$_dir/${FILE}"
   fi
done
