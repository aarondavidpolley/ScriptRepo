#!/bin/bash

echo "***********************************"

for app in /Applications/*.app ; do
	apponly=`cut -d/ -f3 <<< "$app"`
	command=`defaults read "$app"/Contents/Info.plist CFBundleShortVersionString`
	echo "$apponly - $command"
done

echo "***********************************"

for app in /Applications/*/*.app ; do
	apponly=`cut -d/ -f4 <<< "$app"`
	command=`defaults read "$app"/Contents/Info.plist CFBundleShortVersionString`
	echo "$apponly - $command"
done

echo "***********************************"

for app in /Applications/*/*/*.app ; do
	apponly=`cut -d/ -f5 <<< "$app"`
	command=`defaults read "$app"/Contents/Info.plist CFBundleShortVersionString`
	echo "$apponly - $command"
done

echo "***********************************"