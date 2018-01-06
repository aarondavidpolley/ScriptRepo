#!/bin/sh

#need to set password for directory admin & change LDAP node if not running on server#

userList=`dscl /LDAPv3/127.0.0.1 list /Users UserShell | awk '$2 ~ "/dev/null" {print $1}'`

echo "Finding /dev/null..."

for a in $userList ; do
            echo "$a"
            dscl -u diradmin -P <password> /LDAPv3/127.0.0.1 -delete /Users/"$a" UserShell
            dscl -u diradmin -P <password> /LDAPv3/127.0.0.1 -create /Users/"$a" UserShell /bin/bash
done