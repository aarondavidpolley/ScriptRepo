#!/bin/sh

#Set Printer Name
PRINTER="printer_shortname"

/usr/bin/lpstat -p "$PRINTER" -l

sleep 2

/usr/bin/cancel -a -

sleep 2

/usr/sbin/cupsenable "$PRINTER"

sleep 2

/usr/bin/lpstat -p "$PRINTER" -l