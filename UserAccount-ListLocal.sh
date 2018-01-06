#!/bin/sh

#List Users with UniqueID
/usr/bin/dscl . -list /Users UniqueID | grep -Ev "^_|com.*|root|nobody|daemon|\/"