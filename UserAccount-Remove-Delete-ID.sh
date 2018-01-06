#!/bin/sh

#Change 202300002 to ID, such as 501#
#helpful if multiple accounts of same ID#

userList=`dscl . list /Users UniqueID | awk '$2~202300002 {print $1}'`

echo "Deleting account and home directory for the following users..."

for a in $userList ; do
            echo "$a"
            dscl . delete /Users/"$a"  #delete the account
            rm -r /Users/"$a"  #delete the home directory
done