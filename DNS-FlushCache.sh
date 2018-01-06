#!/bin/sh

#For 10.6
/usr/bin/dscacheutil -flushcache

#For 10.10.0 to 10.10.3
discoveryutil mdnsflushcache

#For 10.7, 10.8, 10.9, & 10.10.4 -> 10.11, 10.12, 10.13?
/usr/bin/killall -HUP mDNSResponder
