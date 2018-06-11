source functions.sh

if yn "Use other name of loop device?";then
read -p "Path: " name
losetup $name $(cat loop_file_name.f)
else
losetup -f --show $(cat loop_file_name.f)
fi;
