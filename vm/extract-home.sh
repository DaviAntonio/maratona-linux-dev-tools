#!/usr/bin/guestfish -f

add 'ubuntu-22.04-initial.qcow2'
run
mount '/dev/sda2' '/'

!mkdir -p 'extracted-home.d'

echo "Copying from '/home/icpc' to 'extracted-home.d/icpc-home.tar'"
tar-out '/home/icpc' 'extracted-home.d/icpc-home.tar'
echo "Renaming..."
!mv 'extracted-home.d/icpc-home.tar' "extracted-home.d/icpc-home_$(date --iso-8601='minutes').tar"

echo ""

echo "Unmounting image..."
umount-all

echo "Done"

exit
