#!/bin/bash

#Remove Device Level Preferences#
/usr/bin/defaults delete /Library/Preferences/com.teamviewer.TeamViewer.plist
/usr/bin/defaults delete /Library/Preferences/com.teamviewer.TeamViewerHost.plist
/usr/bin/defaults delete /Library/Preferences/com.teamviewer.teamviewer10.plist
/usr/bin/defaults delete /Library/Preferences/com.teamviewer.teamviewer9.plist
/usr/bin/defaults delete /Library/Preferences/com.teamviewer.teamviewer11.plist
/usr/bin/defaults delete /Library/Preferences/com.teamviewer.teamviewer11.Machine.plist
rm -f /Library/Preferences/com.teamviewer.*


#Remove User Level Preferences#
UHOME="/Users/"

 # get list of all users
_USERS="$(dscl . list /Users | grep -v ^_.*)"
for u in $_USERS
do
   _dir="${UHOME}/${u}Library/Preferences/"
   if [ -d "$_dir" ]
   then
		/usr/bin/defaults delete "${UHOME}/${u}/Library/Preferences/com.teamviewer.TeamViewer.plist"
		/usr/bin/defaults delete "${UHOME}/${u}/Library/Preferences/com.teamviewer.TeamViewerHost.plist"
		/usr/bin/defaults delete "${UHOME}/${u}/Library/Preferences/com.teamviewer.teamviewer10.plist"
		/usr/bin/defaults delete "${UHOME}/${u}/Library/Preferences/com.teamviewer.teamviewer9.plist"
		/usr/bin/defaults delete "${UHOME}/${u}/Library/Preferences/com.teamviewer.teamviewer11.plist"
		/usr/bin/defaults delete "${UHOME}/${u}/Library/Preferences/com.teamviewer.teamviewer11.Machine.plist"
		rm -f "${UHOME}/${u}/Library/Preferences/com.teamviewer.*"
   fi
done
