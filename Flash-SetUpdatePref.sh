#!/bin/bash

echo "Old Value:"
/bin/cat /Library/Application\ Support/Macromedia/mms.cfg

echo "Setting new value..."
echo "AutoUpdateDisable=0" > /Library/Application\ Support/Macromedia/mms.cfg
echo "SilentAutoUpdateEnable=1" >> /Library/Application\ Support/Macromedia/mms.cfg

echo "New Value:"
/bin/cat /Library/Application\ Support/Macromedia/mms.cfg