#!/bin/sh

/usr/local/munki/managedsoftwareupdate --auto

tail -n 100 /Library/Managed\ Installs/Logs/ManagedSoftwareUpdate.log