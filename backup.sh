#! /bin/bash

if [[ $# -ne 2  ]]
then
	echo Usage: ./backup.sh backupdirname filetobackup
	exit 1
fi

if [[ ! -d $1  ]]
then
	echo Error!! $1 is not a valid directory
	exit 1
fi

if [[ ! -f $2 ]]
then
	echo Error!! $2 is not a valid file
	exit 1
fi
filename=$(basename $2)
date=$(date +%Y%m%d)
backuppath=$1/$filename"."$date
if [[ ! -f $backuppath ]]
then
	cp $2 $backuppath
	exit 0
else
	echo Backup file already exists for $date
	exit 1
fi

