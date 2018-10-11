#!/bin/sh

#allow staff to add printers without being admin
/usr/sbin/dseditgroup -o edit -n /Local/Default -a everyone -t group lpadmin