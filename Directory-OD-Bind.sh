#!/bin/sh

# Used ds_open_directory_binding.sh (v1.6) from Deploy Studio as a base for the explicit question.
# I recommend downloading Deploy Studio (http://deploystudio.com) to see other methods but the crux
# of how it is done can be read here. (eg. no error checking here)

ODSERVER="web1.awesome.schools.nsw.edu.au"
BINDUSER="diradmin"
BINDPASS="password"

#Enable LDAPv3 Plugin
defaults write /Library/Preferences/DirectoryService/DirectoryService "LDAPv3" Active 2>&1
chmod 600 /Library/Preferences/DirectoryService/DirectoryService.plist 2>&1

/usr/sbin/ipconfig waitall

#Remove Existing

/usr/sbin/dsconfigldap -f -r $ODSERVER -u $BINDUSER -p $BINDPASS

sleep 5

#Configure LDAP

/usr/sbin/dsconfigldap -a '$ODSERVER' -N 2>&1

#Create Search Policy
/usr/bin/dscl localhost -create /Search SearchPolicy CSPSearchPath 2>&1

#Create Contacts
/usr/bin/dscl localhost -create /Contact SearchPolicy CSPSearchPath 2>&1

#Add OD Server to the search path
/usr/bin/dscl localhost -append /Search CSPSearchPath '/LDAPv3/$ODSERVER' 2>&1

#Add OD Server to Contact Search Policy
/usr/bin/dscl localhost -append /Contact CSPSearchPath '/LDAPv3/$ODSERVER' 2>&1

exit 0
