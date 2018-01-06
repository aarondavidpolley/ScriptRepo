#!/bin/sh

/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin stop web

sleep 3 

/Applications/Server.app/Contents/ServerRoot/usr/sbin/serveradmin start web