#!/bin/sh

CustomID="qwoeijqwekj"

mkdir /tmp/tvinstall/

cd /tmp/tvinstall/

curl -O https://download.teamviewer.com/download/version_11x/CustomDesign/Install%20TeamViewerHost-"$CustomID".pkg

installer -allowUntrusted -verboseR -pkg "/tmp/tvinstall/Install%20TeamViewerHost-"$CustomID".pkg" -target /

sleep 3 

rm -rf /tmp/tvinstall/