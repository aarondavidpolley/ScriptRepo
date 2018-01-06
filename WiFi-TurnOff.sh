#!/bin/sh

#Detect WiFi port number (en0 or en1)
wifi=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`

#Turn off WiFi
/usr/sbin/networksetup -setairportpower $wifi off

#/usr/sbin/networksetup -setairportpower $wifi on