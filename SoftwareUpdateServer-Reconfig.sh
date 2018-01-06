#!/bin/sh

#Firstly, stop the Software Update Service if it's running

sudo serveradmin stop swupdate

#Next, move the old config files out of the way (but keep them just in case for now).

sudo mv /Library/Server/Software\ Update/Cache  /Library/Server/Software\ Update/Cache.old  

#(the server should automatically create a new folder after a few moments)

sudo mv /Library/Server/Software\ Update/Config/swupd.conf /Library/Server/Software\ Update/Config/swupd.conf.old
sudo mv /Library/Server/Software\ Update/Config/swupd.plist /Library/Server/Software\ Update/Config/swupd.plist.old

#... and wipe the old logs and cache...

sudo rm /Library/Server/Software\ Update/Log/*
sudo rm /Library/Server/Software\ Update/Cache/*

#... and the old data directory where the downloaded updates are stored...

sudo rm /Library/Server/Software\ Update/Data/*

#Next, we need to set a couple of things....  Firstly, we need to tell it the port to use to serve updates (strangely it doesn't populate the default port for itself).

sudo serveradmin settings swupdate:portToUse = 8088

#If you use a custom Data directory for your updates (eg. you put them on a different volume), then make the directory, give ownership to softwareupdate and update the config to point at it...

#sudo mkdir /Volumes/myDisk/swupdate
#sudo chown -R _softwareupdate:_softwareupdate /Volumes/myDisk/swupdate
#sudo serveradmin settings swupdate:updatesDocRoot = "/Volumes/myDisk/swupdate/"

#One more thing, depending on the URL you use in your MDM to point clients to the server, you may need to create a soft link in the Data html folder to point clients to the software update catalog file (revise this as necessary if you moved your data folder someplace else): -

#sudo ln -s /Library/Server/Software\ Update/Data/html/index-10.11-10.10-10.9-mountainlion-lion-snowleopard-leopard.merged-1.sucatalog /Library/Server/Software\ Update/Data/html/index.sucatalog

#Ok!  Now fire it back up...

sudo serveradmin start swupdate