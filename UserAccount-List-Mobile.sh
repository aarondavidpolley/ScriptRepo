#!/bin/sh

#With DSCL#

userList=`dscl . list /Users AuthenticationAuthority | awk '$2~/LocalCachedUser/ {print $1}'`

echo "Listing account and home directory for the following users..."

for a in $userList ; do
            echo "$a"
done