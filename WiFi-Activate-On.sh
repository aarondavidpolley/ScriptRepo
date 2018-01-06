#!/bin/sh

#Detect WiFi port number (en0 or en1)
wifi=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`

#Activate Wifi
networksetup -setnetworkserviceenabled Wi-Fi on

sleep 5

#Turn on WiFi
ifconfig $wifi up