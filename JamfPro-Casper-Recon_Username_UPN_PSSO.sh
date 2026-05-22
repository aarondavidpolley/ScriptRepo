#!/bin/sh
####################################################################################################
#
# More information: http://macmule.com/2014/05/04/submit-user-information-from-ad-into-the-jss-at-login-v2/
#
# GitRepo: https://github.com/macmule/SubmitUsernameAtReconForLDAPLookup
#
# License: http://macmule.com/license/
#
# For use with Jamf Pro using Entra ID and Platform SSO
#
# Modified: Aaron Polley @ CompNow 2026-05-22
####################################################################################################

# Get the logged in users username
loggedInUser=$( echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }' )

#UPN provided when using a login mechanism like Jamf Connect
NetworkUser=$(/usr/bin/dscl . -read /Users/"${loggedInUser}" | grep "PlatformSSO" | tail -n 1 | cut -d':' -f2)

if [ "$NetworkUser" = "" ]
then
	echo "User $loggedInUser does not have a UPN for PSSO, exiting $(date)..."
else

echo "Running recon for $loggedInUser setting UPN to $NetworkUser $(date)..."

# Run recon, submitting the users username which as of 8.61+ can then perform an LDAP/CloudIDP lookup
/usr/local/jamf/bin/jamf recon -endUsername "${NetworkUser}"

echo "Finished running recon for $loggedInUser $(date)..."

fi