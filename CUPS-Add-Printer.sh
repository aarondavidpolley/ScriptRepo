#!/bin/sh

#Set Printer Name
PRINTER="printer_shortname"

#Remove Printer#
/usr/sbin/lpadmin -x "$PRINTER"

sleep 2

#Add Printer via Print Server#
#/usr/sbin/lpadmin -p "$PRINTER" -E -v smb://serverhost/"$PRINTER" -P /Library/Printers/PPDs/Contents/Resources/"$PRINTER".ppd -L "Location" -o auth-info-required=negotiate -o printer-is-shared=false

#Add Printer via LPD#
/usr/sbin/lpadmin -p "$PRINTER" -E -v lpd://127.0.0.1 -P /System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/Generic.ppd -L "Location" -o printer-is-shared=false


sleep 2

#Set UseLastPrinter to False EVERYWHERE#

for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/org.cups.PrintingPrefs.plist UseLastPrinter -bool FALSE
  done

for USER_HOME in /Users/*
  do
    USER_UID=`basename "${USER_HOME}"`
    if [ ! "${USER_UID}" = "Shared" ]
    then
      if [ ! -d "${USER_HOME}"/Library/Preferences ]
      then
        mkdir -p "${USER_HOME}"/Library/Preferences
        chown "${USER_UID}" "${USER_HOME}"/Library
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences
      fi
      if [ -d "${USER_HOME}"/Library/Preferences ]
      then
        /usr/bin/defaults write "${USER_HOME}"/Library/Preferences/org.cups.PrintingPrefs.plist UseLastPrinter -bool FALSE
        chown "${USER_UID}" "${USER_HOME}"/Library/Preferences/org.cups.PrintingPrefs.plist
      fi
    fi
  done

#Per User Default Printer Setting:
    for uid in $(/usr/bin/dscl . -list /Users UniqueID | grep -Ev "^_|com.*|root|nobody|daemon|\/" | awk '{print $2}'); do
        # Replace echo with e.g. launchctl load.
        launchctl asuser "$uid" chroot -u "$uid" / echo "Setting default printer for $uid"
        launchctl asuser "$uid" chroot -u "$uid" / lpoptions -d "$PRINTER"
    done