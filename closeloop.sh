#!/bin/bash
loop_name_f="loop_name.f"
if ! [ -e $loop_name_f ];then
	echo "I cannot found loop name file"
	echo "fdisk -l"
	echo "and found some to loop0 or other"
	echo "losetup -d /dev/loop0 as example"
fi;
losetup -d $(cat $loop_name_f)

