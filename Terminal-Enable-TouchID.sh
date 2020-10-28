#!/bin/zsh

echo "Setting up Touch ID for macOS terminal"

#---User Check--#

WHOAREYOU=$(whoami)

if [ "$WHOAREYOU" != "root" ] && [ "$KERNEL" != "Darwin" ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: This is designed to run with sudo/root privileges on macOS, exiting..."
	exit 1
fi

echo "Current contents of /private/etc/pam.d/sudo"

echo

cat /private/etc/pam.d/sudo 

echo

if read -q "choice?Press Y/y to continue with insert of new code "; then
	set -x
	{ set +x; } 2>/dev/null
else
	echo
    echo "'$choice' not 'Y' or 'y'. Exiting..."
    exit 0
fi

echo "Inserting Touch ID PAM Module into sudo config"

sed -i '' '2i\
auth sufficient pam_tid.so \
'  /private/etc/pam.d/sudo


echo "New contents of /private/etc/pam.d/sudo"

echo

cat /private/etc/pam.d/sudo 

echo

echo "Script Complete!"