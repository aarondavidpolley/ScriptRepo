#!/bin/bash
smbSharesName=`mount | grep "smbfs" | awk '{print $1}'`

for a in $smbSharesName ; do
echo "Un-mounting $a"
/sbin/umount -f "$a"
done

afpSharesName=`mount | grep "afpfs" | awk '{print $1}'`

for a in $afpSharesName ; do
echo "Un-mounting $a"
/sbin/umount -f "$a"
done
