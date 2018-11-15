#!/bin/sh

#pmset -- manipulate power management settings

#Older OS
#https://apple.stackexchange.com/questions/116348/how-can-i-enable-and-or-disable-os-xs-power-nap-feature-from-within-terminal
#sudo pmset -c darkwakes 1

#Confirmed syntax on 10.12-10.14

sudo /usr/bin/pmset -c powernap 1 #on
#sudo /usr/bin/pmset -c powernap 0 #off