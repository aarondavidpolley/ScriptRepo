#!/bin/sh

#	-event		The event or trigger that the policy is associated with in the JSS. Historical synonyms include –trigger and –action.
#				Note: Running policy without an event will default to the scheduled event.
#				Other events include: login, logout, startup, networkStateChange, enrollmentComplete, along with custom events.

/usr/local/bin/jamf policy -event Startup -verbose