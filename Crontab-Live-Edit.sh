#!/bin/bash

#write out current crontab
crontab -l > mycron
#echo new cron into cron file
echo "0 19 * * * /usr/local/bin/backupDBs.sh ALL auto 1 2>&1 >> /dev/null" >> mycron
#install new cron file
crontab mycron
rm mycron
crontab -l

########

