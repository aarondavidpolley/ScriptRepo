#!/bin/sh

/usr/bin/defaults write /Library/MonitoringClient/ClientSettings ClientGroup -string "CLICK_TO_EDIT" && \
/usr/bin/curl -L1 https://DOMAIN.monitoringclient.com/downloads/MonitoringClient.pkg > /tmp/MonitoringClient.pkg && \
/usr/sbin/installer -target / -pkg /tmp/MonitoringClient.pkg && \
/bin/rm /tmp/MonitoringClient.pkg
