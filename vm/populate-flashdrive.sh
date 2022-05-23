#!/usr/bin/guestfish -f

add 'flashdrive.qcow2'
run
mount '/dev/sda1' '/'

echo "Erasing '/packages'"
rm-rf /packages
echo "Listing '/'"
ls '/'
echo ""

echo "Copying new files into '/packages'"
mkdir '/packages'

#packages is a directory
#copy-in 'packages' '/'

#packages is a symbolic link to a directory
<! find packages/ -type f -exec printf "copy-in %s /packages\n" {} \;

echo "Listing '/'"
ls '/'
echo ""

echo "Listing '/packages'"
ls '/packages'

exit
