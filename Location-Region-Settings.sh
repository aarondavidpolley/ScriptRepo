#!/bin/sh

# enable location services
/bin/launchctl unload /System/Library/LaunchDaemons/com.apple.locationd.plist
uuid=$(/usr/sbin/system_profiler SPHardwareDataType | grep "Hardware UUID" | cut -c22-57)
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd."$uuid" LocationServicesEnabled -int 1
/usr/bin/defaults write /var/db/locationd/Library/Preferences/ByHost/com.apple.locationd.notbackedup."$uuid" LocationServicesEnabled -int 1
/usr/sbin/chown -R _locationd:_locationd /var/db/locationd
/bin/launchctl load /System/Library/LaunchDaemons/com.apple.locationd.plist

sleep 5

# enable network time
/usr/sbin/systemsetup -setusingnetworktime off
sleep 3
/usr/sbin/systemsetup -setusingnetworktime on

# set the time server

/usr/sbin/systemsetup -setnetworktimeserver time.asia.apple.com

/usr/sbin/systemsetup -settimezone Australia/Sydney


#Set The Keyboard Layout - Function

PLBUDDY=/usr/libexec/PlistBuddy
NAME="Australian"
LAYOUT="15"

update_kdb_layout() {
  ${PLBUDDY} -c "Delete :AppleCurrentKeyboardLayoutInputSourceID" "${1}" &>/dev/null
  if [ ${?} -eq 0 ]
  then
    ${PLBUDDY} -c "Add :AppleCurrentKeyboardLayoutInputSourceID string com.apple.keylayout.${NAME}" "${1}"
  fi

for SOURCE in AppleDefaultAsciiInputSource AppleCurrentAsciiInputSource AppleCurrentInputSource AppleEnabledInputSources AppleSelectedInputSources
  do
    ${PLBUDDY} -c "Delete :${SOURCE}" "${1}" &>/dev/null
    if [ ${?} -eq 0 ]
    then
      ${PLBUDDY} -c "Add :${SOURCE} array" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0 dict" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0:InputSourceKind string 'Keyboard Layout'" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0:'KeyboardLayout ID' integer ${LAYOUT}" "${1}"
      ${PLBUDDY} -c "Add :${SOURCE}:0:'KeyboardLayout Name' string '${NAME}'" "${1}"
    fi
  done
}

#Set The Keyboard Layout - Task

update_kdb_layout "/Library/Preferences/com.apple.HIToolbox.plist" "${NAME}" "${LAYOUT}"

for HOME in /Users/*
  do
    if [ -d "${HOME}"/Library/Preferences ]
    then
      cd "${HOME}"/Library/Preferences
      HITOOLBOX_FILES=`find . -name "com.apple.HIToolbox.*plist"`
      for HITOOLBOX_FILE in ${HITOOLBOX_FILES}
      do
        update_kdb_layout "${HITOOLBOX_FILE}" "${NAME}" "${LAYOUT}"
      done
    fi
done

#Setting the OS language

LANG="en"

update_language() {
  ${PLBUDDY} -c "Delete :AppleLanguages" "${1}" &>/dev/null
  if [ ${?} -eq 0 ]
  then
    ${PLBUDDY} -c "Add :AppleLanguages array" "${1}"
    ${PLBUDDY} -c "Add :AppleLanguages:0 string '${LANG}'" "${1}"
  fi
}

#Setting the OS language - Task

update_language "/Library/Preferences/.GlobalPreferences.plist" "${LANG}"

for HOME in /Users/*
  do
    if [ -d "${HOME}"/Library/Preferences ]
    then
      cd "${HOME}"/Library/Preferences
      GLOBALPREFERENCES_FILES=`find . -name ".GlobalPreferences.*plist"`
      for GLOBALPREFERENCES_FILE in ${GLOBALPREFERENCES_FILES}
      do
        update_language "${GLOBALPREFERENCES_FILE}" "${LANG}"
      done
    fi
done

#Setting the region

REGION="en_AU"

update_region() {
  ${PLBUDDY} -c "Delete :AppleLocale" "${1}" &>/dev/null
  ${PLBUDDY} -c "Add :AppleLocale string ${REGION}" "${1}" &>/dev/null
  ${PLBUDDY} -c "Delete :Country" "${1}" &>/dev/null
  ${PLBUDDY} -c "Add :Country string ${REGION:3:2}" "${1}" &>/dev/null
}

#Setting the region - Task

update_region "/Library/Preferences/.GlobalPreferences.plist" "${REGION}"

for HOME in /Users/*
  do
    if [ -d "${HOME}"/Library/Preferences ]
    then
      cd "${HOME}"/Library/Preferences
      GLOBALPREFERENCES_FILES=`find . -name ".GlobalPreferences.*plist"`
      for GLOBALPREFERENCES_FILE in ${GLOBALPREFERENCES_FILES}
      do
        update_region "${GLOBALPREFERENCES_FILE}" "${REGION}"
      done
    fi
done

exit 0
