#!/bin/bash

loop_name=""

need_priveleges(){
        echo "Need priveleges, run this script as root (sudo)"
}

yn(){
        read -p "$1? [y/n]: " sure
        while [[ "$sure" != "y"* ]] && [[ "$sure" != "n"* ]];
        do
                read -p "$1? [y/n]: " sure
        done;
        if [[ $sure == "y"* ]];then
                return 0
        else
                return 1
        fi;

}


create_loop(){
        if ! [ -e $1 ];then
                touch $1
        else
                if ! yn "IT WILL DELETE/ERASE YOUR FILE WITH NAME $1 YOU ARE SURE?";then
                        exit 0
                fi;
        fi;

        dd if=/dev/zero of=$1 count=1 bs=$2

        if yn "Create new loop device? ";then
                read -sp "Write name of the loop device: " loop_n
                count_loops=$(ls /dev/ | grep loop | wc -l)
                mknod -m 766 /dev/$loop_n b 7 $count_loops 2> /dev/null || need_priveleges
                loop_name="/dev/$loop_n"
                losetup /dev/$loop_n $1
        else
                loop_name=$(losetup -f --show $1)
        fi;
}

pvcreat(){
	pvcreate $1
	vgcreate loopcrypt0 $1
	if ! yn "I will create one main volume?";then
	while yn "Create more a logical volume? (you will create main volume!)"
	do
		read -s "Size (G/M/K/...): " size
		read -s "Name: " name
		lvcreate -L $size -n "/dev/loopcrypt0/$name"
	done;
	else
		lvcreate -L $2 -n "/dev/loopcrypt0/main"
	fi;
	if ! [ -e "/dev/loopcrypt0/main" ];then
		echo "You will create main volume!!!!!!"
		echo "I WILL DELETE All your volumes and give more!"
		sleep 1s
		for dev in "/dev/loopcrypt0"
		do
			echo "Delete $dev"
			lvremove $dev
			pvcreat $1 $2
		done
	fi;

}
