#!/bin/bash

EveryoneUID=$(dscl . read /Groups/everyone GeneratedUID | awk '{print $2}')
lpadminCHECK=$(dscl . read /Groups/_lpadmin NestedGroups | grep "$EveryoneUID")

if [[ -z $lpadminCHECK ]]; then

echo "Everyone Group has not been added to lpadmin group"

exit 0

else

echo "Everyone can administer print queues"

exit 1

fi