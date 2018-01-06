#!/bin/sh

#Using DSCL
/usr/bin/dscl . -passwd /Users/<SHORTNAME> <OLDPASS> <NEWPASS>

#Using SysAdminCtl
/usr/sbin/sysadminctl -resetPasswordFor <local user name> -newPassword <new password> [-passwordHint <password hint>]
