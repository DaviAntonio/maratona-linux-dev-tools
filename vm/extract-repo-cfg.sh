#!/usr/bin/guestfish -f

add 'ubuntu-22.04-initial.qcow2'
run
mount '/dev/sda2' '/'

!mkdir -p 'pull-from-vm'

echo "Copying from '/etc/fstab' and '/etc/apt/sources.list' to 'pull-from-vm'"
copy-out '/etc/fstab' '/etc/apt/sources.list' 'pull-from-vm'
echo "Renaming..."
!for f in pull-from-vm/*; do mv "${f}" "${f}_$(date --iso-8601='minutes')"; done

echo ""

echo "Unmounting image..."
umount-all

echo "Done"

exit
