#!/bin/sh

#With DSCL#

#New User Script - Aaron Polley 2016

#Make sure to perform a find and replace for "shortname" to be the user short name that you want
#Make sure to perform a find and replace for "Full Name" to be the user pretty name that you want
#Make sure to perform a find and replace for "password" to set the user password to what you want
#Make sure to set an unused UniqueID for your user - user accounts created by the system have IDs 501, 502, 503, etc hence I have 599 in this script
#Have a look at the "/Library/User Pictures/" folder on any mac and choose another photo if you don't like the Eagle I have chosen
#Remove the last line of "/usr/sbin/dseditgroup -o edit -a shortname -t user admin" if you don't want them to be an Admin user, just Standard

# Create user record in directory services
dscl . -create /Users/shortname
dscl . -create /Users/shortname RealName "Full Name"
dscl . -create /Users/shortname PrimaryGroupID 20
dscl . -create /Users/shortname UniqueID 599
dscl . -create /Users/shortname UserShell /bin/bash
dscl . -passwd /Users/shortname password
dscl . -create /Users/shortname Picture "/Library/User Pictures/Animals/Eagle.tif"
dscl . -create /Users/shortname NFSHomeDirectory /Users/shortname


#Create user home folder from system template
#cp -R /System/Library/User\ Template/English.lproj /Users/shortname
#cp -R /System/Library/User\ Template/Non_localized/Documents /Users/shortname/
#cp -R /System/Library/User\ Template/Non_localized/Downloads /Users/shortname/
#cp -R /System/Library/User\ Template/Non_localized/Library/* /Users/shortname/Library/

#Set Correct Home Folder Permissions
#sudo chown -R shortname:staff /Users/shortname
#sudo chmod -R -N /Users/shortname
#sudo chmod -R 755 /Users/shortname
#sudo chmod 700 /Users/shortname/Desktop /Users/shortname/Documents /Users/shortname/Downloads /Users/shortname/Library /Users/shortname/Movies /Users/shortname/Music /Users/shortname/Pictures
#sudo chmod 777 /Users/shortname/Public
#sudo chmod 733 /Users/shortname/Public/Drop\ Box

#Set User to have admin rights
/usr/sbin/dseditgroup -o edit -a shortname -t user admin