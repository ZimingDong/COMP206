#!/bin/bash
# Ziming Dong ID: 260951177


mkproject(){
	if [[ -d $1 ]]
	then
		echo 'Directory name already exists'
		exit 1
	else
		mkdir -p $1/{archive,backups,docs/html,docs/txt,assets,database,src/sh,src/c}	
	fi
}
x=$1
if [[ -z $1 ]]
then
	mkproject myproject
	x=myproject
else
	mkproject $1
	place=$1/src
	shift
	for i in "$@"
	do
		cp $i $place
	done
	
		
fi

echo -e \
'#!/bin/bash
# Ziming Dong ID: 260951177


if [[ "$#" -eq "0" ]]
then 
	cd ..
	cp -r src/* backups
	cd backups
fi

if [[ $1 != -* ]]
then
	cd ..
	for i in "$@"
	do
		cp $i backups
	done
	cd backups
else
	cd ..
	if [[ -z $3 ]]
	then
		case $1 in
			"-x") tar -cvf backups/$2 src/*;;
			"-z") tar -cvzf backups/$2 src/*;;
		*) echo "That switch is not supported.";;
		esac
	else
		case $1 in
			"-x")
			       	path="$2"
				var="src/$3"
				shift
				shift
				shift
				for i in "$@"
				do
					var+=" src/$i"
				done

				tar -cvf backups/$path $var;;
			"-z")
				path="$2"
				var="src/$3"
				shift
				shift
				shift
				for i in "$@"
				do
					var+=" src/$i"
				done
			       	tar -cvzf backups/$path $var;;
		*) echo "That swirch is not supported.";;
		esac
	cd backups
	fi
fi



' > $x/backups/mkbackup.sh
chmod +x $x/backups/mkbackup.sh
