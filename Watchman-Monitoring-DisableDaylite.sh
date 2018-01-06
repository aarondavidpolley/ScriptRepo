#!/bin/bash

#Disable Daylite Monitoring for ladmin#
/usr/libexec/PlistBuddy -c "Set :Users_To_Monitor:ladmin bool false" /Library/MonitoringClient/PluginSupport/check_daylite_client_settings.plist