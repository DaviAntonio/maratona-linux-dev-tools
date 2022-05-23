#!/usr/bin/guestfish -f

add 'ubuntu-22.04-initial.qcow2'
run
mount '/dev/sda2' '/'

!mkdir -p 'push-to-vm'

echo "Copying from 'push-to-vm/fstab' to '/etc/fstab'"
copy-in 'push-to-vm/fstab' '/etc'

echo "Copying from 'push-to-vm/sources.list' to '/etc/apt/sources.list'"
copy-in 'push-to-vm/sources.list' '/etc/apt'

echo ""

echo "Unmounting..."
umount-all

echo "Done"

exit
