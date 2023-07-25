#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${DISK_LOCATION}'"
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
