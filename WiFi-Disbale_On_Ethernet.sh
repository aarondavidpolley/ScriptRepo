#!/bin/sh

#Detect WiFi port number (en0 or en1)
wifi=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Wi-Fi/,/Ethernet/' | awk 'NR==2' | cut -d " " -f 2`
ethernet=`/usr/sbin/networksetup -listallhardwareports | awk '/Hardware Port: Ethernet/,/Wi-Fi/' | awk 'NR==2' | cut -d " " -f 2`

EthStatus=`/sbin/ifconfig $ethernet | grep "status" | awk '{print $2}'`

#Check If WiFi is primary connection#

if [ "$wifi" == "en0" ]; then

echo "Wi-Fi is primary connection, exiting"

exit 0

else

	#Check If Ethernet active#
	if [ "$EthStatus" == "active" ]; then

		echo "Ethernet active, disabling Wi-Fi"

		#Turn off WiFi
		ifconfig $wifi down

		sleep 2

		#De-Activate Wifi
		networksetup -setnetworkserviceenabled Wi-Fi off

	else

		echo "Ethernet inactive, enabling Wi-Fi"

		#Activate Wifi
		networksetup -setnetworkserviceenabled Wi-Fi on

		sleep 5

		#Turn on WiFi
		ifconfig $wifi up

	fi

fi