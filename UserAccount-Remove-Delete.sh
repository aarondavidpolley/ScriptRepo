#!/bin/sh

#With DSCL#
dscl . delete /Users/<user>  #delete the account
rm -r /Users/<user>  #delete the home directory

#With SysAdminCtl#
/usr/sbin/sysadminctl -deleteUser <user name> [-secure || -keepHome]