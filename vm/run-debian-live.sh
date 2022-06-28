#!/bin/bash

readonly BIOS_LOCATION="/usr/share/OVMF/OVMF_CODE.fd"
readonly IMAGE_LOCATION="link-debian-live-11.2.0-amd64-mate+nonfree.iso"
readonly DISK_LOCATION="ubuntu-22.04-initial.qcow2"
readonly VM_NAME="ubuntu-22.04-debian-live"
readonly IPV4_NETWORK="192.168.3.0/24"
readonly IPV4_DHCP_FIRST_ADDR="192.168.3.220"
readonly P22_FWD="10022"

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

no_image_location_error()
{
	printf "No image defined\n"
	exit 3
}

no_disk_location_error()
{
	printf "No disk defined\n"
	exit 4
}

no_ipv4_network_error()
{
	printf "No IPV4 network defined\n"
	exit 5
}

no_ipv4_first_addr_error()
{
	printf "No IPV4 first address for DHCP server defined\n"
	exit 6
}

no_port_22_forward()
{
	printf "No forward port for port 22 (SSH) defined\n"
	exit 7
}

# specified parth not found
missing_bios()
{
	printf "BIOS file not found on '%s'\n" "${1}"
	exit 8
}

missing_image()
{
	printf "Image file not found on '%s'\n" "${1}"
	exit 9
}

missing_disk()
{
	printf "Disk file not found on '%s'\n" "${1}"
	exit 10
}

[ ! -z "${VM_NAME}" ] && printf "VM_NAME=%s\n" "${VM_NAME}" || no_vm_name_error
[ ! -z "${BIOS_LOCATION}" ] && printf "BIOS_LOCATION=%s\n" "${BIOS_LOCATION}" || no_bios_location_error
[ ! -z "${IMAGE_LOCATION}" ] && printf "IMAGE_LOCATION=%s\n" "${IMAGE_LOCATION}" || no_image_location_error
[ ! -z "${DISK_LOCATION}" ] && printf "DISK_LOCATION=%s\n" "${DISK_LOCATION}" || no_disk_location_error
[ ! -z "${IPV4_NETWORK}" ] && printf "IPV4_NETWORK=%s\n" "${IPV4_NETWORK}" || no_ipv4_network_error
[ ! -z "${IPV4_DHCP_FIRST_ADDR}" ] && printf "IPV4_DHCP_FIRST_ADDR=%s\n" "${IPV4_DHCP_FIRST_ADDR}" || no_ipv4_first_addr_error
[ ! -z "${P22_FWD}" ] && printf "P22_FWD=%s (Port 22 forwarded to %s)\n" "${P22_FWD}" "${P22_FWD}" || no_port_22_forward

[ -f "${BIOS_LOCATION}" ] && printf "BIOS_LOCATION=%s\n" "${BIOS_LOCATION}" || missing_bios "${BIOS_LOCATION}"
[ -f "${IMAGE_LOCATION}" ] && printf "IMAGE_LOCATION=%s\n" "${IMAGE_LOCATION}" || missing_image "${IMAGE_LOCATION}"
[ -f "${DISK_LOCATION}" ] && printf "DISK_LOCATION=%s\n" "${DISK_LOCATION}" || missing_disk "${DISK_LOCATION}"

echo "Booting machine with HDD and removable media"

qemu-system-x86_64 \
-k pt-br \
-machine type=pc-q35-7.0,accel=kvm \
-cpu Haswell \
-m 4G \
-bios "${BIOS_LOCATION}" \
-drive file="${IMAGE_LOCATION}",format=raw,if=none,media=cdrom,index=0,id=drive-cd1,readonly=on \
-device virtio-scsi-pci,id=scsi0 \
-device scsi-cd,bus=scsi0.0,drive=drive-cd1,id=cd1,bootindex=0 \
-drive file="${DISK_LOCATION}",format=qcow2,if=none,media=disk,index=1,id=drive-hd1,readonly=off \
-device scsi-hd,bus=scsi0.0,drive=drive-hd1,id=hd1,bootindex=1 \
-boot menu=on \
-netdev user,id=net0,net="${IPV4_NETWORK}",dhcpstart="${IPV4_DHCP_FIRST_ADDR}",hostfwd=tcp::"${P22_FWD}"-:22 \
-device virtio-net-pci,netdev=net0 \
-rtc base=localtime,clock=vm \
-vga virtio \
-display gtk \
-monitor stdio \
-name "${VM_NAME}"
