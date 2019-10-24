#!/bin/bash

username="apiuser"
password="password"
URL="https://jss.company.com.au:8443"

mylist=$(curl -k -s -H "Accept: application/xml" -u $username:$password $URL/JSSResource/buildings | xmllint -format - | grep -E "<name>" | cut -d '>' -f2 | cut -d '<' -f1)

OLDIFS=$IFS
IFS=$'\n'       # make newlines the only separator
for i in $mylist; do echo "Building: $i"; done
IFS=$OLDIFS