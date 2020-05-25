#!/bin/bash

if [ $EUID != 0 ]; then
	echo "Please run as root or sudo"
	exit 1
fi

# Asks for dir and check if it exists. 
read -p "Enter full dir of where the backups will be located: " backupdir

# Checks and creates dir if needed
[ ! -d "$backupdir" ] && mkdir -p "$backupdir"

echo
echo "Choose one of the following: "
echo "1 - Backup all VMs"
echo "2 - Backup a specific VM"
echo
read -p "Enter your choice: " ans
if [ "$ans" == 1 ]; then
	cd /var/lib/libvirt/images
	for g in *.qcow2; do
		echo "Backing up $g"
		name=$g
		final=$(basename $name .qcow2)
		gzip < $g > $backupdir/$final.qcow2.backup.gz
		virsh dumpxml $final > $backup/$final.xml;
		done			
elif [ "$ans" == 2 ]; then
	cd /var/lib/libvirt/images
	echo
	read -p "Enter VM to backup: " vmbackup
	gzip < $vmbackup.qcow2 > $backupdir/$vmbackup.qcow2.backup.gz
	virsh dumpxml $vmbackup > $backupdir/$vmbackup.xml
else
	echo "Unknown answer"
	exit 1
fi


