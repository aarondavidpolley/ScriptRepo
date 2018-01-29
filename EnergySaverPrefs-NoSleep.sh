#!/bin/sh

#Does not work over ARD - seems to like being run as current user with sudo#

#Usage: systemsetup -getsleep
#	Display amount of idle time until computer, display and hard disk sleep.
#
#Usage: systemsetup -setsleep <minutes>
#	Set amount of idle time until computer, display and hard disk sleep to <minutes>.
#	Specify "Never" or "Off" for never.

systemsetup -setsleep 60

sleep 3

#
#Usage: systemsetup -getcomputersleep
#	Display amount of idle time until computer sleeps.
#
#Usage: systemsetup -setcomputersleep <minutes>
#	Set amount of idle time until compputer sleeps to <minutes>.
#	Specify "Never" or "Off" for never.

systemsetup -setcomputersleep off

sleep 3

#
#Usage: systemsetup -getdisplaysleep
#	Display amount of idle time until display sleeps.
#
#Usage: systemsetup -setdisplaysleep <minutes>
#	Set amount of idle time until display sleeps to <minutes>.
#	Specify "Never" or "Off" for never.

systemsetup -setdisplaysleep 60

sleep 3

#
#Usage: systemsetup -getharddisksleep
#	Display amount of idle time until hard disk sleeps.
#
#Usage: systemsetup -setharddisksleep <minutes>
#	Set amount of idle time until hard disk sleeps to <minutes>.

systemsetup -setharddisksleep 60

sleep 3


#Usage: systemsetup -getwakeonnetworkaccess
#	Display whether wake on network access is on or off.
#
#Usage: systemsetup -setwakeonnetworkaccess <on off>
#	Set wake on network access to either <on> or <off>.

systemsetup -setwakeonnetworkaccess on

sleep 3

#
#Usage: systemsetup -getrestartpowerfailure
#	Display whether restart on power failure is on or off.
#
#Usage: systemsetup -setrestartpowerfailure <on off>
#	Set restart on power failure to either <on> or <off>.
#

systemsetup -setrestartpowerfailure on

sleep 3

#Usage: systemsetup -getrestartfreeze
#	Display whether restart on freeze is on or off.
#
#Usage: systemsetup -setrestartfreeze <on off>
#	Set restart on freeze to either <on> or <off>.
#

systemsetup -setrestartfreeze on

sleep 3

#Usage: systemsetup -getallowpowerbuttontosleepcomputer
#	Display whether the power button is able to sleep the computer.
#
#Usage: systemsetup -setallowpowerbuttontosleepcomputer <on off>
#	Enable or disable whether the power button can sleep the computer.

systemsetup -setallowpowerbuttontosleepcomputer off

sleep 3

defaults read /Library/Preferences/com.apple.PowerManagement.plist