#!/bin/sh

#From https://twitter.com/eholtam/status/1169620999479996416

sqlite3 "$(getconf DARWIN_USER_DIR)/com.apple.notificationcenter/db2/db" "select * from app;"