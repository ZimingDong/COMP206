#!/bin/bash
if [[ $# -ne 1 ]] && [[ $# -ne 2 ]]
then
	echo Usage: ./chkbackups.sh backupdirname [sourcedir]
	exit 1
fi
if [[ $# -eq 1 ]]
then
	cur=$(pwd)
else
	if [[ ! -d $2 ]]
	then
		echo Error!! $2 is not a valid directory
		exit 1
	elif [[ -z "$(ls -A $2)" ]]
	then
		echo Error!! $2 has no files
		exit 1
	fi
	cur=$2
fi
echo $cur

c=0
for file in $(ls $cur)
do
	today=$(date +%Y%m%d)
	backupfile=$1/$file.$today
	if [[ ! -f $backupfile ]]
	then
		c=$((c+1))
		cp $cur/$file $backupfile
		echo $file does not have backup for today
	fi
done

if [[ $c -eq 0 ]]
then
	echo All files in $2 have backups for today in $1
fi
exit 0
