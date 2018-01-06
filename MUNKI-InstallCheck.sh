#!/bin/sh

#!/bin/bash
file="/usr/local/munki/managedsoftwareupdate"
if [ -f "$file" ]
then
	echo "Munki is installed"
else
	echo "NO Munki"
fi