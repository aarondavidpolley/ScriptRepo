#!/bin/sh

#Adapted from https://www.jamf.com/jamf-nation/feature-requests/7758/exclude-hardware-with-t2-chips-from-filevault-reporting

if [ ! -e /usr/sbin/system_profiler ]
then
	echo "<result>SCRIPT ERROR - Binary Missing</result>"
	exit 1
fi

#
# Using system_profiler to check for 
# SPi bridge data type reporting as 
# "T2"
#

T2_DETECT=$(/usr/sbin/system_profiler SPiBridgeDataType | grep -w "T2" | head -n 1)

#
# If T2 chip is detected then result is "Yes"
# Otherwise result is "No".
# 

if [ ! -z "${T2_DETECT}" ]
then
      result="Yes"
   else
      result="No"
fi

echo "<result>$result</result>"

exit 0