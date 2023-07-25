#!/bin/bash

# [ -z "${VAR}" ] && echo "unset" || echo "set"
[ -z "${SOURCED_ENV_VARS_SH}" ] || exit 0

readonly BIOS_LOCATION=""
readonly IMAGE_LOCATION=""
readonly DEBIAN_LIVE_IMAGE_LOCATION=""
readonly GPARTED_LIVE_IMAGE_LOCATION=""
readonly DISK_LOCATION=""
readonly FLASHDRIVE_LOCATION=""

readonly DISK_SIZE=""
readonly FLASHDRIVE_SIZE=""

readonly VM_INITIAL_NAME=""
readonly VM_NAME=""
readonly VM_NO_NET_NAME=""
readonly VM_DEBIAN_LIVE_NAME=""
readonly VM_GPARTED_LIVE_NAME=""
readonly IPV4_NETWORK=""
readonly IPV4_DHCP_FIRST_ADDR=""
readonly P22_FWD=""
readonly MACHINE_TYPE=""
readonly MACHINE_CFG="type=${MACHINE_TYPE},accel=kvm"
readonly CPU_MODEL=""
readonly CPU_NUMBER=""
readonly MACHINE_MEMORY_SIZE=""

readonly UNSET_WARNING="is unset or empty"

echo "BIOS_LOCATION=${BIOS_LOCATION:?${UNSET_WARNING}}"
echo "IMAGE_LOCATION=${IMAGE_LOCATION:?${UNSET_WARNING}}"
echo "DEBIAN_LIVE_IMAGE_LOCATION=${DEBIAN_LIVE_IMAGE_LOCATION:?${UNSET_WARNING}}"
echo "GPARTED_LIVE_IMAGE_LOCATION=${GPARTED_LIVE_IMAGE_LOCATION:?${UNSET_WARNING}}"
echo "DISK_LOCATION=${DISK_LOCATION:?${UNSET_WARNING}}"
echo "FLASHDRIVE_LOCATION=${FLASHDRIVE_LOCATION:?${UNSET_WARNING}}"

echo "DISK_SIZE=${DISK_SIZE:?${UNSET_WARNING}}"
echo "FLASHDRIVE_SIZE=${FLASHDRIVE_SIZE:?${UNSET_WARNING}}"

echo "VM_INITIAL_NAME=${VM_INITIAL_NAME:?${UNSET_WARNING}}"
echo "VM_NAME=${VM_NAME:?${UNSET_WARNING}}"
echo "VM_NO_NET_NAME=${VM_NO_NET_NAME:?${UNSET_WARNING}}"
echo "VM_DEBIAN_LIVE_NAME=${VM_DEBIAN_LIVE_NAME:?${UNSET_WARNING}}"
echo "VM_GPARTED_LIVE_NAME=${VM_GPARTED_LIVE_NAME:?${UNSET_WARNING}}"

echo "IPV4_NETWORK=${IPV4_NETWORK:?${UNSET_WARNING}}"
echo "IPV4_DHCP_FIRST_ADDR=${IPV4_DHCP_FIRST_ADDR:?${UNSET_WARNING}}"
echo "P22_FWD=${P22_FWD:?${UNSET_WARNING}}"
echo "MACHINE_TYPE=${MACHINE_TYPE:?${UNSET_WARNING}}"
echo "MACHINE_CFG=${MACHINE_CFG:?${UNSET_WARNING}}"
echo "CPU_MODEL=${CPU_MODEL:?${UNSET_WARNING}}"
echo "CPU_NUMBER=${CPU_NUMBER:?${UNSET_WARNING}}"
echo "MACHINE_MEMORY_SIZE=${MACHINE_MEMORY_SIZE:?${UNSET_WARNING}}"

abort_if_bios_not_found() {
	if [[ ! -e "${BIOS_LOCATION}" ]]; then
		echo "UEFI/BIOS not found on '${BIOS_LOCATION}'"
		echo "Try 'apt install ovmf'"
		exit 1
	fi
}

abort_if_image_not_found() {
	if [[ ! -e "${IMAGE_LOCATION}" ]]; then
		echo "Installation image not found on '${IMAGE_LOCATION}'"
		exit 2
	fi
}

abort_if_debian_live_image_not_found() {
	if [[ ! -e "${DEBIAN_LIVE_IMAGE_LOCATION}" ]]; then
		echo "Debian Live image not found on '${DEBIAN_LIVE_IMAGE_LOCATION}'"
		exit 2
	fi
}

abort_if_gparted_live_image_not_found() {
	if [[ ! -e "${GPARTED_LIVE_IMAGE_LOCATION}" ]]; then
		echo "Gparted Live image not found on '${GPARTED_LIVE_IMAGE_LOCATION}'"
		exit 2
	fi
}

abort_if_disk_not_found() {
	if [[ ! -e "${DISK_LOCATION}" ]]; then
		echo "Virtual Machine disk not found on '${DISK_LOCATION}'"
		exit 3
	fi
}

abort_if_flashdrive_not_found() {
	if [[ ! -e "${FLASHDRIVE_LOCATION}" ]]; then
		echo "Flashdrive disk not found on '${FLASHDRIVE_LOCATION}'"
		exit 4
	fi
}

readonly SOURCED_ENV_VARS_SH=1
