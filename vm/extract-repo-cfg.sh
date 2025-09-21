#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
run
mount '/dev/sda2' '/'

!mkdir -p 'pull-from-vm'

echo "Copying from '/etc/fstab' and '/etc/apt/sources.list' to 'pull-from-vm'"
copy-out '/etc/fstab' '/etc/apt/sources.list' '/etc/apt/sources.list.d/ubuntu.sources' 'pull-from-vm'
echo "Renaming..."
!for f in pull-from-vm/*; do mv "${f}" "${f}_$(date --iso-8601='minutes')"; done

echo ""

echo "Unmounting image..."
umount-all

echo "Done"

exit
