#!/bin/sh

mkdir /tmp/munkiinstall/

cd /tmp/munkiinstall/

curl -O http://munki.yourdomain.com.au/munkitools.pkg

installer -allowUntrusted -verboseR -pkg "/tmp/munkiinstall/munkitools.pkg" -target /

sleep 3 

defaults write /Library/Preferences/ManagedInstalls SoftwareRepoURL "http://munki.yourdomain.com.au/munki_repo"
defaults write /Library/Preferences/ManagedInstalls ClientIdentifier "general"
defaults write /Library/Preferences/ManagedInstalls UnattendedAppleUpdates 1
defaults write /Library/Preferences/ManagedInstalls InstallAppleSoftwareUpdates 1

sleep 3

defaults read /Library/Preferences/ManagedInstalls

echo "Setting munki to bootstrap mode..."
touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup
 
echo "Finished applying firstboot settings."
 
echo "Sleeping for 5 seconds..."

sleep 5

sudo /bin/bash -c "$(curl -s http://munki.yourdomain.com.au/munkireport/index.php?/install)"

sleep 5

rm -rf /tmp/munkiinstall/