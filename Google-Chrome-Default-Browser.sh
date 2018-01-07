#!/bin/bash

################################################################################
# Author: 	Aaron Polley                                                       #
# Date:		12/05/2017                                                         #
# Version:	1.0                                                                #
# Purpose:  Default web browser setting to Chrome for user accounts            #
#           This should be run as a initial login script via LauchAgent        #
################################################################################

#---Variables and such---#
script_version="1.0"
user_id=`id -u`
user_name=`id -un $user_id`
home_dir="/Users/$user_name"
chrome_default_done="$home_dir/.chromedefaultdone"
log_file="$home_dir/Library/Logs/chrome_default.log"
os_vers=`sw_vers -productVersion | awk -F "." '{print $2}'`

#---Redirect output to log---#
exec >> $log_file 2>&1

set_chrome_default(){
echo "*************************************************************************"
echo `date "+%a %b %d %H:%M:%S"` " - Chrome default beginning v${script_version}"
echo `date "+%a %b %d %H:%M:%S"` "     - User:              $user_name"
echo `date "+%a %b %d %H:%M:%S"` "     - User ID:           $user_id"
echo `date "+%a %b %d %H:%M:%S"` "     - Home Dir:          $home_dir"
echo `date "+%a %b %d %H:%M:%S"` "     - OS Vers:           10.${os_vers}"

echo `date "+%a %b %d %H:%M:%S"` " - Setting default web browser to Chrome..."

# Open Chrome and set default
/usr/bin/open -a "Google Chrome" --args --make-default-browser
#sleep 1
#/usr/bin/osascript -e 'tell application "System Events" to tell process "CoreServicesUIAgent" to tell window 1 to click button 1'

echo `date "+%a %b %d %H:%M:%S"` " - Chrome Default complete!"
echo "*************************************************************************"
#touch $chrome_default_done

}

#---Script Actions---#
# Don't run for the Admin user
if [ $user_name = "ladmin" ]; then
    exit 0
fi
if [ ! -f $chrome_default_done ]; then        # Check if the dock setup script has been run before
    set_chrome_default
fi

exit 0