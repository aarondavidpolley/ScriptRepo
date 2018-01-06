#!/bin/sh

#With SysAdminCtl#
#/usr/sbin/sysadminctl -addUser <user name> [-fullName <full name>] [-UID <user ID>] [-shell <path to shell>] [-password <user password>] [-hint <user hint>] [-home <full path to home>] [-admin] [-picture <full path to user image>]

USERNAME="ladmin"
FULLNAME="Local Admin"
USERID="599"
PASSWORD="password"

sysadminctl -addUser $USERNAME -fullName "$FULLNAME" -UID=$USERID -password $PASSWORD -admin

sleep 3

#To Set As Hidden#
dscl . create /Users/"$USERNAME" IsHidden 1