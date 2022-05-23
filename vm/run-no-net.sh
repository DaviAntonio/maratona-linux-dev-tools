#!/bin/bash

readonly BIOS_LOCATION="/usr/share/OVMF/OVMF_CODE.fd"
readonly DISK_LOCATION="ubuntu-22.04-initial.qcow2"
readonly FLASHDRIVE_LOCATION="flashdrive.qcow2"
readonly VM_NAME="ubuntu-22.04-maratona"

[ ! -z "${VM_NAME}" ] && printf "VM_NAME=%s\n" "${VM_NAME}" || no_vm_name_error
[ ! -z "${BIOS_LOCATION}" ] && printf "BIOS_LOCATION=%s\n" "${BIOS_LOCATION}" || no_bios_location_error
[ ! -z "${FLASHDRIVE_LOCATION}" ] && printf "FLASHDRIVE_LOCATION=%s\n" "${FLASHDRIVE_LOCATION}" || no_flashdrive_location_error
[ ! -z "${DISK_LOCATION}" ] && printf "DISK_LOCATION=%s\n" "${DISK_LOCATION}" || no_disk_location_error

[ -f "${BIOS_LOCATION}" ] && printf "BIOS_LOCATION=%s\n" "${BIOS_LOCATION}" || missing_bios "${BIOS_LOCATION}"
[ -f "${FLASHDRIVE_LOCATION}" ] && printf "FLASHDRIVE_LOCATION=%s\n" "${FLASHDRIVE_LOCATION}" || missing_flashdrive "${FLASHDRIVE_LOCATION}"
[ -f "${DISK_LOCATION}" ] && printf "DISK_LOCATION=%s\n" "${DISK_LOCATION}" || missing_disk "${DISK_LOCATION}"

# undefined variables
no_vm_name_error()
{
	printf "No VM name defined\n"
	exit 1
}

no_bios_location_error()
{
	printf "No BIOS defined\n"
	exit 2
}

no_flashdrive_location_error()
{
	printf "No flashdrive image location defined\n"
	exit 3
}

no_disk_location_error()
{
	printf "No disk defined\n"
	exit 4
}

# specified parth not found
missing_bios()
{
	printf "BIOS file not found on '%s'\n" "${1}"
	exit 8
}

missing_flashdrive()
{
	printf "Flashdrive image not found on '%s'\n" "${1}"
	exit 9
}

missing_disk()
{
	printf "Disk file not found on '%s'\n" "${1}"
	exit 10
}

echo "Booting machine with HDD and packages' disk"

qemu-system-x86_64 \
-k pt-br \
-machine accel=kvm \
-m 4G \
-bios "${BIOS_LOCATION}" \
-drive file="${DISK_LOCATION}",index=0,media=disk \
-drive file="${FLASHDRIVE_LOCATION}",index=1,media=disk \
-boot menu=on \
-nic none \
-rtc base=localtime \
-vga qxl \
-monitor stdio \
-name "${VM_NAME}"
