#!/bin/sh

# Make adobe acrobat Pro (DC) the default PDF reader for any current logged in user (designed to be run as root/sudo/jamf policy)
# Inspired by: https://www.jamf.com/jamf-nation/discussions/30016/set-acrobat-reader-dc-as-the-default-pdf-handler#responseChild175405

	for pid_uid in $(ps -axo pid,uid,args | grep -i "[l]oginwindow.app" | awk '{print $1 "," $2}'); do
        pid=$(echo $pid_uid | cut -d, -f1)
        uid=$(echo $pid_uid | cut -d, -f2)
        # Replace echo with e.g. launchctl load.
        launchctl asuser "$uid" chroot -u "$uid" / python -c 'from LaunchServices import LSSetDefaultRoleHandlerForContentType; LSSetDefaultRoleHandlerForContentType("com.adobe.pdf", 0x00000002, "com.adobe.Acrobat.Pro")'
    done

# Running as user, just run:
# python -c 'from LaunchServices import LSSetDefaultRoleHandlerForContentType; LSSetDefaultRoleHandlerForContentType("com.adobe.pdf", 0x00000002, "com.adobe.Acrobat.Pro")'