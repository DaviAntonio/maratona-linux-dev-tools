#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda2' '/'

!mkdir -p 'extracted-home.d'

echo "Copying from '/home/icpc' to 'extracted-home.d/icpc-home.tar'"
tar-out '/home/icpc' 'extracted-home.d/icpc-home.tar'
echo "Renaming..."
!mv 'extracted-home.d/icpc-home.tar' "extracted-home.d/$(date --iso-8601='minutes')_icpc-home.tar"

echo ""

echo "Unmounting image..."
umount-all

echo "Done"

exit
