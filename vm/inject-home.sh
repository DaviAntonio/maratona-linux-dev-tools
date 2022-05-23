#!/usr/bin/guestfish -f

add 'ubuntu-22.04-initial.qcow2'
run
mount '/dev/sda2' '/'

!mkdir -p 'push-to-home.d/tests'

echo "Copying from 'push-to-home.d' to '/home/icpc'"
copy-in 'push-to-home.d/' '/home/icpc'

echo ""

echo "Unmounting..."
umount-all

echo "Done"

exit
