#!/bin/sh

# TOGGLE ALL ON
# before setting values quit system preferences & stop software update - stops deafults cache breaking 'AutomaticCheckEnabled'
/usr/bin/osascript -e "tell application \"System Preferences\" to quit"
/usr/sbin/softwareupdate --schedule off
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticCheckEnabled -bool YES
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist AutomaticDownload -bool YES
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist ConfigDataInstall -bool YES
/usr/bin/defaults write /Library/Preferences/com.apple.SoftwareUpdate.plist CriticalUpdateInstall -bool YES
/usr/bin/defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdateRestartRequired -bool YES
/usr/bin/defaults write /Library/Preferences/com.apple.commerce.plist AutoUpdate -bool YES

/usr/sbin/softwareupdate --schedule on

# See the results…
open "/System/Library/PreferencePanes/AppStore.prefPane/"
