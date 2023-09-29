#!/bin/zsh

#Use this for macOS Sonoma (14.x)
#See Terminal-Enable-TouchID.sh for older approach

# sudo_local: local config file which survives system update and is included for sudo
# We will copy the template file and add following line to enable Touch ID for sudo
# auth       sufficient     pam_tid.so

echo "Setting up Touch ID for macOS terminal"

#---User Check--#

WHOAREYOU=$(whoami)

if [ "$WHOAREYOU" != "root" ]
then
	echo "$(date '+%Y-%m-%d_%H-%M-%S') ERROR: This is designed to run with sudo/root privileges on macOS, exiting..."
	exit 1
fi

if [ ! -e "/etc/pam.d/sudo_local" ]
then

echo "Copying /etc/pam.d/sudo_local.template to /etc/pam.d/sudo_local"

cp /etc/pam.d/sudo_local.template /etc/pam.d/sudo_local

fi

echo "Contents of /etc/pam.d/sudo_local"

echo

cat /etc/pam.d/sudo_local

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

sed -i '' -e '$ d' /etc/pam.d/sudo_local

sed -i '' '$a\
auth sufficient pam_tid.so \
'  /etc/pam.d/sudo_local

echo "New contents of /etc/pam.d/sudo_local"

echo

cat /etc/pam.d/sudo_local 

echo

echo "Script Complete!"