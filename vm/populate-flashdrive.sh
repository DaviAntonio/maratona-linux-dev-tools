#!/usr/bin/guestfish -f

# Ugly hack yet necessary, as guestfish lacks variables
# Guestfish asks 'sh' to interpret the inline script and will happily try to
# execute whathever 'sh' sent to stdout
<!. ./env-vars.sh > /dev/null; echo "add '${FLASHDRIVE_LOCATION}'"
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

# Packages is a symbolic link to a directory
<! find packages/ -type f -exec printf "copy-in %s /packages\n" {} \;

echo "Listing '/'"
ls '/'
echo ""

echo "Listing '/packages'"
ls '/packages'

exit
