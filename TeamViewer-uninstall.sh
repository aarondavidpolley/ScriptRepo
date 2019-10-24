#!/bin/bash

##TeamViewer Uninstall##

echo "Looking for components to remove..."
TVapps=$(find /Applications -name "*eam*iewer*.app" 2>/dev/null)
QSapps=$(find /Applications -name "*Remote Support.app" 2>/dev/null)
TVlaunchA=$(find /Library/LaunchAgents -name "*eam*iewer*.plist")
TVlaunchD=$(find /Library/LaunchDaemons -name "*eam*iewer*.plist")
TVproc=$(pgrep -l TeamViewer | awk '{print $1}')
loggedInUser=$(/usr/bin/python -c 'from SystemConfiguration import SCDynamicStoreCopyConsoleUser; import sys; username = (SCDynamicStoreCopyConsoleUser(None, None, None) or [None])[0]; username = [username,""][username in [u"loginwindow", None, u""]]; sys.stdout.write(username + "\n");')



#####################################
## DO STUFF ##
#####################################

#unload user services#
echo "Unloading launchD services for logged in users..."
    # Run postinstall actions for all logged in users.
    for pid_uid in $(ps -axo pid,uid,args | grep -i "[l]oginwindow.app" | awk '{print $1 "," $2}'); do
        pid=$(echo $pid_uid | cut -d, -f1)
        uid=$(echo $pid_uid | cut -d, -f2)
        # Replace echo with e.g. launchctl load.
        launchctl asuser "$uid" chroot -u "$uid" / echo "$DateTime - Executing postinstall for $uid"
        for i in $TVlaunchA;
        do
        	launchctl asuser "$uid" chroot -u "$uid" / launchctl unload "$i"
        done
    done

for i in $TVlaunchA;
do
	sudo -u "$loggedInUser" launchctl unload "$i"
done

#unload root services# 
echo "Unloading launchD services for system/root..."   
for i in $TVlaunchD;
do
	launchctl unload "$i"
done    
    
#Kill everything else#
sleep 1
echo "Killing left over processes..." 
for i in $TVproc;
do
	kill "$i"
done

#Remove LaunchAgents#
echo "Removing LaunchAgents..." 
for i in $TVlaunchA;
do
	rm "$i"
done

#Remove LaunchDaemons#
echo "Removing LaunchDaemons..." 
for i in $TVlaunchD;
do
	rm "$i"
done

#Remove Apps#
sleep 1
echo "Removing Apps..." 
for i in $TVapps;
do
	rm -rf "$i"
done

for i in $QSapps;
do
	rm -rf "$i"
done

#Remove Device Level Preferences#
echo "Removing Preferences..."
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

#Check for processes again#
echo "Checking for left over processes..."
TVproc2=$(pgrep -l TeamViewer | awk '{print $1}')

#Kill everything else again#
sleep 1
echo "Killing left over processes..."
for i in $TVproc2;
do
	kill "$i"
done

touch /var/db/receipts/au.com.compnow.uninstall_teamviewer

exit 0