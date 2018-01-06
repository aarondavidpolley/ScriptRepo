#!/bin/sh

#Copy Disabled Agents to Active
cp /Library/LaunchAgents\ \(Disabled\)/com.smarttech.SBWDKService.plist /Library/LaunchAgents/
cp /Library/LaunchAgents\ \(Disabled\)/com.smarttech.boardservice.plist /Library/LaunchAgents/
cp /Library/LaunchAgents\ \(Disabled\)/com.smarttech.floatingtools.plist /Library/LaunchAgents/
cp /Library/LaunchAgents\ \(Disabled\)/com.smarttech.ink.plist /Library/LaunchAgents/