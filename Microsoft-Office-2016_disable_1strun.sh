#!/bin/bash

#Source: https://github.com/rtrouton/rtrouton_scripts/blob/master/rtrouton_scripts/disable_office_2016_first_run_settings/disable_office_2016_first_run_dialog_windows.sh

#Modifed by Aaron David Polley Dec 1st 2017

# Office 2016 for Mac presents "first run" dialogs to the user to market some of its new features.
# This script will suppress these "first run" dialogs using the following settings:
# 
# Setting: kSubUIAppCompletedFirstRunSetup1507 – boolean value (true / false)
# Function: Suppresses the "What’s New" dialog for Office 2016 applications' first launch
#
# Setting: FirstRunExperienceCompletedO15 – boolean value (true / false)
# Function: Suppresses additional "What’s New" dialog for Outlook and OneNote.
# Note: That is a capital letter O in "O15", not zero15.
#
# Setting: SendAllTelemetryEnabled – boolean value (true / false)
# Function: Suppresses the offer to send crash reports to Microsoft
#
# Source for settings: 
# http://macops.ca/disabling-first-run-dialogs-in-office-2016-for-mac/
# Set whether you want to send diagnostic info back to Microsoft. If you want to
# offer the choice of sending diagonostic data back to Microsoft, set the following
# value for the submit_diagnostic_data_to_microsoft variable:
#
# submit_diagnostic_data_to_microsoft=true
#
# By default, the values in this script are set to send no diagnostic data to Microsoft:
submit_diagnostic_data_to_microsoft=false
DisableOffice2016FirstRun(){
# This function will disable the first run dialog windows for all Office 2016 apps.
# It will also set the desired diagnostic info settings for Office application.
   /usr/bin/defaults write /Library/Preferences/com.microsoft."$app" kSubUIAppCompletedFirstRunSetup1507 -bool true
   /usr/bin/defaults write /Library/Preferences/com.microsoft."$app" SendAllTelemetryEnabled -bool "$submit_diagnostic_data_to_microsoft"
# Outlook and OneNote require one additional first run setting to be disabled
if [[ $app == "Outlook" ]] || [[ $app == "onenote.mac" ]]; then
     /usr/bin/defaults write /Library/Preferences/com.microsoft."$app" FirstRunExperienceCompletedO15 -bool true
fi
}
# Run the DisableOffice2016FirstRun function for all apps for Office 2016
# application to disable the first run dialogs for that Office 2016 application.

app=Excel
DisableOffice2016FirstRun

sleep 1

app=onenote.mac
DisableOffice2016FirstRun

sleep 1

app=Outlook
DisableOffice2016FirstRun

sleep 1

app=Powerpoint
DisableOffice2016FirstRun

sleep 1

app=Word
DisableOffice2016FirstRun

exit 0