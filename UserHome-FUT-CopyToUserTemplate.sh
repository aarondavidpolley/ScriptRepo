#!/bin/bash

FILE="/Library/Preferences/com.squirrels.Reflection.plist"

for USER_TEMPLATE in "/System/Library/User Template"/*
  do
    cp "${FILE}" "${USER_TEMPLATE}"/Library/Preferences/
  done