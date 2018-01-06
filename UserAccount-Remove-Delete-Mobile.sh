#!/bin/sh

#With DSCL#

userList=`dscl . list /Users AuthenticationAuthority | awk '$2~/LocalCachedUser/ {print $1}'`

echo "Deleting account and home directory for the following users..."

for a in $userList ; do
            echo "$a"
            dscl . delete /Users/"$a"  #delete the account
            rm -r /Users/"$a"  #delete the home directory
done