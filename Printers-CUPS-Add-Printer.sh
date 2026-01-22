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

#Set Driver Path or Model
#use lpinfo -lm to see installed models
DRIVER="/System/Library/Frameworks/ApplicationServices.framework/Versions/A/Frameworks/PrintCore.framework/Versions/A/Resources/Generic.ppd"
MODEL="drv:///sample.drv/generpcl.ppd"

#Remove Printer#
/usr/sbin/lpadmin -x "${PRINTER}"

sleep 2

#Add Printer via Print Server#
#/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v smb://"$NETPRINT"/"${QUEUE}" -m "$MODEL" -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

#Add Printer via LPD#
#/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v lpd://"$NETPRINT"/"${QUEUE}" -P "$DRIVER" -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

#Add Printer via IPP Everywhere/AirPrint
/usr/sbin/lpadmin -p "$PRINTER" -D "${PRINTER_UI_NAME}" -E -v ipp://"${NETPRINT}"/ipp/print -m everywhere -L "$LOCATION" -o auth-info-required=negotiate -o printer-is-shared=false

sleep 2