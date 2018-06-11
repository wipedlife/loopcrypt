#!/bin/bash
create_fs(){
 . functions.sh
 echo "I get error, in mount, i guess that i will do format or is already mounted, if it's mounted (control+C)? "
 if yn "Do it";then
		mkfs.ext4 /dev/mapper/mainloopcrypt
		mount /dev/mapper/mainloopcrypt $place
 else
		exit 1
 fi;
}

cryptsetup luksOpen /dev/loopcrypt0/main mainloopcrypt
read -p "Mount place?: " place
if ! [ -d $place ];then
	echo "It's not directory or not exist, i will create directory?"
	ls $place && echo "Yes is file or some, it will delete that"
	. functions.sh
	if yn "Sure?";then
		rm -f $place
		mkdir $place
	else
		exit 1
	fi;
fi;

mount /dev/mapper/mainloopcrypt $place || create_fs

echo "Mounted i think. write 'cd $place'"
echo $place > place_mount.f
