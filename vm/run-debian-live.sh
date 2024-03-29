#!/bin/bash

source './env-vars.sh'

echo "Booting machine '${VM_DEBIAN_LIVE_NAME}' with HDD and Debian Live"

abort_if_bios_not_found

abort_if_disk_not_found
abort_if_debian_live_image_not_found

qemu-system-x86_64 \
-k pt-br \
-machine "${MACHINE_CFG}" \
-cpu "${CPU_MODEL}" -smp "${CPU_NUMBER}" \
-m "${MACHINE_MEMORY_SIZE}" \
-bios "${BIOS_LOCATION}" \
-device virtio-scsi-pci,id=scsi0 \
-drive file="${DEBIAN_LIVE_IMAGE_LOCATION}",format=raw,if=none,media=cdrom,index=0,id=drive-cd1,readonly=on \
-device scsi-cd,bus=scsi0.0,drive=drive-cd1,id=cd1,bootindex=0 \
-drive file="${DISK_LOCATION}",format=qcow2,if=none,media=disk,index=1,id=drive-hd1,readonly=off \
-device scsi-hd,bus=scsi0.0,drive=drive-hd1,id=hd1,bootindex=1 \
-boot menu=on \
-netdev user,id=net0,net="${IPV4_NETWORK}",dhcpstart="${IPV4_DHCP_FIRST_ADDR}",hostfwd=tcp::"${P22_FWD}"-:22 \
-device virtio-net-pci,netdev=net0 \
-rtc base=localtime,clock=vm \
-device virtio-vga-gl \
-display gtk,gl=on \
-monitor stdio \
-name "${VM_DEBIAN_LIVE_NAME}"
