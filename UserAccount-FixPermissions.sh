#!/bin/bash

#Please change the userName to the short name of the desired user to fix

userName="user"

chown -R "$userName":staff /Users/"$userName"

/usr/sbin/diskutil resetUserPermissions / `id -u`