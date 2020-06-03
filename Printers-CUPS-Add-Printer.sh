#!/bin/sh

#Set Printer Name
PRINTER="printer_shortname"
PRINTER_UI_NAME="${PRINTER}"

#Set Print Server or Printer Direct Host/IP
NETPRINT="10.11.12.13"

#Set Printer Location
LOCATION="Print Room"

#Set Printer Queue
QUEUE="QUEUE%20NAME"

#Set Driver Path
DRIVER="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/Generic.ppd"

#Remove Printer#
/usr/sbin/lpadmin -x "${PRINTER}"

sleep 2

#Add Printer via Print Server#
#/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v smb://"$NETPRINT"/"${QUEUE}" -P "$DRIVER" -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

#Add Printer via LPD#
#/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v lpd://"$NETPRINT"/"${QUEUE}" -P "$DRIVER" -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

#Add Printer via IPP Everywhere/AirPrint
/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v ipp://"${NETPRINT}"/ipp/print -m everywhere -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

sleep 2

#Set UseLastPrinter to False EVERYWHERE#

for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    /usr/bin/defaults write "${USER_TEMPLATE}"/Library/Preferences/org.cups.PrintingPrefs.plist UseLastPrinter -bool FALSE
  done

for USER_HOME in /Users/*
  do
    USER_UID=$(basename "${USER_HOME}")
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
    for uid in $(/usr/bin/dscl . -list /Users UniqueID | grep -Ev "^_|com.*|root|nobody|daemon|\\/" | awk '{print $2}'); do
        # Replace echo with e.g. launchctl load.
        launchctl asuser "$uid" chroot -u "$uid" / echo "Setting default printer for $uid"
        launchctl asuser "$uid" chroot -u "$uid" / lpoptions -d "$PRINTER"
    done