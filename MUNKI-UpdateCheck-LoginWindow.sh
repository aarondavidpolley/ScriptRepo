#!/bin/bash

echo "Kick Start munki in bootstrap mode..."
touch /Users/Shared/.com.googlecode.munki.checkandinstallatstartup

sleep 5

rm /Users/Shared/.com.googlecode.munki.checkandinstallatstartup