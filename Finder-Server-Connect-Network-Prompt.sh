#!/bin/bash
#Script to disable behaviour introduced in macOS Sierra to prompt to connect to server rather than quietly authorising

defaults write /Library/Preferences/com.apple.NetworkAuthorization AllowUnknownServers -bool YES

exit 0
