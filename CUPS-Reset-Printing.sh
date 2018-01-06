#!/bin/sh

/usr/bin/lpstat -p | cut -d' ' -f2 | xargs -I{} /usr/sbin/lpadmin -x {} 
echo "Printer System Reset" 
