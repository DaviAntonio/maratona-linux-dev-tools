#!/bin/bash

readonly DRIVE="$1"
readonly DRIVE_BACKUP="${DRIVE}_backup"

usage()
{
	printf "Converts image to RAW and compresses it\n"
	printf "Usage:\tcompress-drive drive-to-compress\n"
	printf "The image is backed up with a '_backup' suffix\n"

	exit 1
}

missing_drive()
{
	printf "Drive specified on '%s' was not found\n" "${1}"
	exit 2
}

[ -n "${DRIVE}" ] || usage

if [ -f "${DRIVE}" ]; then
	printf "DRIVE=%s\n" "${DRIVE}"
else
	missing_drive "${DRIVE}"
fi

printf "Converting to RAW %s\n" "${DRIVE}"
mv "${DRIVE}" "${DRIVE_BACKUP}"
sync

qemu-img convert -p -O raw "${DRIVE_BACKUP}" "${DRIVE}"

# virt-sparsify --format raw --convert raw ubuntu-24.04-initial.raw ubuntu-24.04-initial2.raw

sync
