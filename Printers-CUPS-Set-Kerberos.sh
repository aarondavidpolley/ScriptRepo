#!/bin/sh
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
# launchd daemon to enable Kerberos authentication on local SMB print queues
# Matt Hansen on (7/29/2011) - College of Education, Penn State University
# Use with 10.6.x+, Known Bug in 10.6.7 - http://support.apple.com/kb/TS3759
# Modified 2019-10-24 by https://github.com/aarondavidpolley/
#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#-#
# Preflight
DATEFORMAT="+%m.%d.%Y-%H:%M:%S"
SCRIPT=$(basename "${0}")

echo "$(date ${DATEFORMAT}) - ${SCRIPT} - Running"

## User must be root or a member of '_lpadmin' to use the lpadmin utility
id -un | grep -q 'root' || id -Gn | grep -q '_lpadmin' || exit 1

## Verify printers.conf file exists so at least one printer is installed
if [ -e /etc/cups/printers.conf ]
then

	## Enable Kerberos printing on all locally installed SMB printers
	for PRINTER in $(lpstat -v | grep 'smb://' | awk '{print $3}' | tr -d :);do
		lpadmin -p "${PRINTER}" -o printer-is-shared=false
		echo "$(date ${DATEFORMAT}) - ${SCRIPT} - ${PRINTER} - Sharing Disabled"
		lpadmin -p "${PRINTER}" -o auth-info-required=negotiate
		echo "$(date ${DATEFORMAT}) - ${SCRIPT} - ${PRINTER} - Enabled for Kerberos"
	done
	echo "$(date ${DATEFORMAT}) - ${SCRIPT} - Finished with printer list"
else
	echo "$(date ${DATEFORMAT}) - ${SCRIPT} - No printers installed"
fi

exit 0