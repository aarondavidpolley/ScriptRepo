#!/bin/bash

#apt
#For modern versions of apt there is a specific switch for this:

apt list --upgradable

#apt-get
#For the old apt-get command the -u switch shows a list of packages that are available for upgrade:

apt-get -u upgrade --assume-no