#!/bin/bash

#Used to generate CSR on Mac/unix system with openssl
#Call script as 'GenerateCSR.sh FQDN' ie 'GenerateCSR.sh server.mydomain.com'

FQDN="${1}"

if [ -z "${FQDN}" ]
then
	FQDN="New_Cert_$(date '+%Y-%m-%d_%H-%M-%S')"
else

	echo "FQDN: ${FQDN}"
fi
	

cd ~/Desktop/

openssl req -out "${FQDN}.csr" -new -newkey rsa:2048 -nodes -keyout "${FQDN}.key"