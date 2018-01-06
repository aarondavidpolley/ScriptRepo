#!/bin/bash

#Run as the current User - i.e in a login script#

#Sets Email Login as current user shortname#
LOGINNAME=$USER

#Sets email address as Email address recorded against user in local directory#
EMAIL="`dscl . read /Users/$USER EMailAddress | cut -d ":" -f 2 | sed -e 's/^[ \t]*//'`"
 
/usr/bin/security \
       -v add-internet-password \
       -a "$EMAIL" \
       -l "accounts.google.com ($LOGINNAME)" \
       -c "apsr" \
       -s "accounts.google.com" \
       -r "http" \
       -j "add-internet-password debugging entry" \
       -w "MyPassword" \
       -T "/Applications/Utilities/Keychain Access.app" \
       -T "/usr/bin/security" \
       -T "/Applications/Safari.app" \
       -t form \
        Internet