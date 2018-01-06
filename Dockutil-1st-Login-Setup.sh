#!/bin/bash

################################################################################
# Author: 	Calum Hunter                                                       #
# Date:		12/01/2016                                                         #
# Version:	1.91                                                               #
# Purpose:  Default dock settings for user accounts                            #
#           Configured via Dockutil                                            #
#           This should be run as a initial login script via LauchAgent        #
# Modified 15 December 2016 - Aaron Polley
################################################################################

#---Variables and such---#
script_version="1.91"
user_id=`id -u`
user_name=`id -un $user_id`
home_dir="/Users/$user_name"
dock_setup_done="$home_dir/.docksetupdone"
log_file="$home_dir/Library/Logs/dock_setup.log"
os_vers=`sw_vers -productVersion | awk -F "." '{print $2}'`

#---Redirect output to log---#
exec >> $log_file 2>&1

initial_dock_setup(){   # Remove the dock items we don't want
echo "*************************************************************************"
echo `date "+%a %b %d %H:%M:%S"` " - Dock setup beginning v${script_version}"
echo `date "+%a %b %d %H:%M:%S"` "     - User:              $user_name"
echo `date "+%a %b %d %H:%M:%S"` "     - User ID:           $user_id"
echo `date "+%a %b %d %H:%M:%S"` "     - Home Dir:          $home_dir"
echo `date "+%a %b %d %H:%M:%S"` "     - OS Vers:           10.${os_vers}"
echo `date "+%a %b %d %H:%M:%S"` " - Waiting for presence of dock plist..."
while [ ! -f ~/Library/Preferences/com.apple.dock.plist ]; do 
    sleep 1     # We sleep 1 seconds here so we don't totally kill the cpu usage
done
sleep 2     # We sleep 2 seconds here so that Apple can set the dock corectly before we modify it
echo `date "+%a %b %d %H:%M:%S"` " - Removing all Dock items..."
/usr/local/bin/dockutil --remove all
sleep 1
echo `date "+%a %b %d %H:%M:%S"` " - Adding new Dock Items..."

/usr/local/bin/dockutil --add /Applications/Launchpad.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Safari.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/iTunes.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Dictionary.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Calculator.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/iMovie.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/GarageBand.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Firefox.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Google\ Chrome.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Keynote.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Microsoft\ Office\ 2011/Microsoft\ PowerPoint.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Microsoft\ Office\ 2011/Microsoft\ Word.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Pages.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Reflector.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Photos.app/ --allhomes --no-restart

/usr/local/bin/dockutil --add /Applications/Webstart.webloc --section others --allhomes --no-restart

/usr/local/bin/dockutil --add /Users/Shared/Server\ Access/\<\ Faculty\ \>.inetloc --section others --allhomes --no-restart

/usr/local/bin/dockutil --add /Users/Shared/Server\ Access/Sentral\ Login.webloc --section others --allhomes

echo `date "+%a %b %d %H:%M:%S"` " - Dock setup complete!"
echo "*************************************************************************"
touch $dock_setup_done

}

#---Script Actions---#
# Don't run for the Admin user
if [ $user_name = "ladmin" ]; then
    exit 0
fi
if [ ! -f $dock_setup_done ]; then        # Check if the dock setup script has been run before
    initial_dock_setup
fi

exit 0