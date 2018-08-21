#!/bin/bash

# Check the Jamf Pro WebApp version via CLI
# Assumes Linux installer path and root context only (not multi context)

cat /usr/local/jss/tomcat/webapps/ROOT/WEB-INF/xml/version.xml | grep webApplicationVersion | cut -f2 -d ">" | cut -f1 -d "<"