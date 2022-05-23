#!/bin/bash

readonly DRIVE="$1"
readonly DRIVE_BACKUP="${DRIVE}_backup"

[ ! -z "${DRIVE}" ] || usage
[ -f "${DRIVE}" ] && printf "DRIVE=%s\n" "${DRIVE}" || missing_drive "${DRIVE}"

usage()
{
	printf "Converts image to QCOW2 and compresses it\n"
	printf "Usage:\tcompress-drive drive-to-compress\n"
	printf "The image is backed up with a '_backup' suffix\n"

	exit 1
}

missing_drive()
{
	printf "Drive specified on '%s' was unfound" "${1}"
	exit 2
}

printf "Converting to QCOW2 and compressing %s\n" "${DRIVE}"
mv "${DRIVE}" "${DRIVE_BACKUP}"
sync
#qemu-img convert -c -p -O qcow2 "${DRIVE_BACKUP}" "${DRIVE}"
qemu-img convert --salvage -c -p -O qcow2 "${DRIVE_BACKUP}" "${DRIVE}"
sync
