if ! [ -e "place_mount.f" ];then
	echo "You not mounted? I not know place which you mount"
	echo "fdisk -l"
	echo "Found there some"
	echo "cryptsetup luksClose mainloopcrypt as example (/dev/mapper/mainloopcrypt)"
fi
umount $(cat place_mount.f)
cryptsetup luksClose mainloopcrypt
