#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2014/05/04/submit-user-information-from-ad-into-the-jss-at-login-v2/
#
# GitRepo: https://github.com/macmule/SubmitUsernameAtReconForLDAPLookup
#
# License: http://macmule.com/license/
#
# Modified: Aaron Polley @ CompNow 2024-02-01
####################################################################################################

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

#UPN provided when using a login mechanism like Jamf Connect
NetworkUser=$(/usr/bin/dscl . -read /Users/"${loggedInUser}" | grep "NetworkUser" | head -n 1 | cut -d' ' -f2)

echo "Running recon for $loggedInUser setting UPN to $NetworkUser $(date)..."

# Run recon, submitting the users username which as of 8.61+ can then perform an LDAP/CloudIDP lookup
/usr/local/jamf/bin/jamf recon -endUsername "${NetworkUser}"

echo "Finished running recon for $loggedInUser $(date)..."