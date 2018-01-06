#!/bin/sh

# Set amount of idle time in minutes until a computer sleeps. Specify "Never" or "Off" for computers that should never sleep.

systemsetup -setsleep never

# Set the amount of idle time in minutes until the hard disk sleeps.

systemsetup -setharddisksleep off

# Set the amount of idle time in minutes until the display sleeps.

systemsetup -setdisplaysleep 60

# Set whether the computer will wake from sleep when a network admin packet is sent to it.

systemsetup -setwakeonnetworkaccess on
