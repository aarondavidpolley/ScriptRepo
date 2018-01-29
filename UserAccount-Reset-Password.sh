#!/bin/bash

USERNAME="ladmin"
NEWPASS="NewPassRocks"
OLDPASS="MyOLD"
PASSTEST=`/usr/bin/dscl . auth "$USERNAME" "$OLDPASS"`
HINT="Contact Your IT Support"

if[ $PASSTEST == "" ]; then

/usr/sbin/sysadminctl -resetPasswordFor $USERNAME -newPassword $NEWPASS -passwordHint $HINT

else

echo "Old password does not match, are you resetting the right one?"

fi	