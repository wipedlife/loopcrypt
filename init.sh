#!/bin/bash
if [ $# \< 2 ];then
	echo "$0 NameOfLoopDevice Size(M/G/..)"
	exit 0;
fi;

. functions.sh

error(){
	echo $1
	exit 1
}

whereis lvm 1> /dev/zero || error "You are not have lvm, but it need that"
whereis cryptsetup 1> /dev/zero || error "you are not have cryptsetup/dm-crypt/luks, but it need that"


create_loop $1 $2
pvcreat $loop_name $2
echo "Your loop name new is $loop_name"
#if yn "I will install on others?";then
	for device in "/dev/loopcrypt0/*"
	do
		#if [[ "$device" == "/dev/loopcrypt0/main" ]];then
		#	continue;
		#fi;
		cryptsetup luksFormat $device
	done
#fi;

echo "Okey, look to mount.sh now"

echo `pwd`/$1 > "loop_file_name.f"
echo $loop_name > "loop_name.f"
