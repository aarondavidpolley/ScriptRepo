#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2014/05/04/submit-user-information-from-ad-into-the-jss-at-login-v2/
#
# GitRepo: https://github.com/macmule/SubmitUsernameAtReconForLDAPLookup
#
# License: http://macmule.com/license/
#
# Modified: Aaron Polley @ CompNow 2019-09-17
####################################################################################################

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )


echo "Running recon for $loggedInUser $(date)..."

# Run recon, submitting the users username which as of 8.61+ can then perform an LDAP lookup
/usr/local/jamf/bin/jamf recon -endUsername "${loggedInUser}"

echo "Finished running recon for $loggedInUser $(date)..."