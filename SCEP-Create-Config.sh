#!/bin/bash

#SCEP = Microsoft System Center Endpoint Protection for Mac
#Designed to work with v4.5.32.0, may work with earlier versions
#Purpose: Create config file with the below settings to use with SCEP-Restore-Config.sh

rm /tmp/SCEP_Settings_Import

tee /tmp/SCEP_Settings_Import <<\EOF

[global]
privileged_users = "root"
av_scan_app_unwanted = yes
samples_send_target = ""
av_exclude = "/Volumes/WIP*::/Volumes/WIP_Archive*::"
scheduler_tasks = "1;Log maintenance;;0;0 3 * * * *;@logs;3;Startup file check;;0;startonce;@sscan lowest;4;Startup file check;;0;engine;@sscan lowest;20;Weekly scan;;;0 2 * * * 1;@uscan scan_deep:/;64;Regular automatic update;;;repeat 60;@update;66;Automatic update after user logon;;;login 60;@update;"

[fac]
av_scan_adv_heur = yes
av_scan_app_unsafe = yes
action_av = "scan"
av_clean_mode = "none"


[start]
av_clean_mode = "none"

[scan_smart]
av_clean_mode = "none"

EOF

chmod 755 /tmp/SCEP_Settings_Import

exit 0