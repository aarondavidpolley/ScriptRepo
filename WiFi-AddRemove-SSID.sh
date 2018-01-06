#!/bin/sh

#Detect WiFi port number (en0 or en1)
wifi=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`

##networksetup -removepreferredwirelessnetwork <device name> <network>
/usr/sbin/networksetup -removepreferredwirelessnetwork $wifi SSID

##networksetup -addpreferredwirelessnetworkatindex <device name> <network> <index> <security type> [password]
/usr/sbin/networksetup -addpreferredwirelessnetworkatindex $wifi SSID 1 WPA2 Personal password