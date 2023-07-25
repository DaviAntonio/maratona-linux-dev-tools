#!/bin/bash

source './env-vars.sh'

echo "Booting machine '${VM_NAME}' with HDD and packages' disk"

abort_if_bios_not_found

abort_if_image_not_found
abort_if_disk_not_found
abort_if_flashdrive_not_found

qemu-system-x86_64 \
-k pt-br \
-machine "${MACHINE_CFG}" \
-cpu "${CPU_MODEL}" -smp "${CPU_NUMBER}" \
-m "${MACHINE_MEMORY_SIZE}" \
-bios "${BIOS_LOCATION}" \
-device virtio-scsi-pci,id=scsi0 \
-drive file="${DISK_LOCATION}",format=qcow2,if=none,media=disk,index=0,id=drive-hd0,readonly=off \
-device scsi-hd,bus=scsi0.0,drive=drive-hd0,id=hd0,bootindex=0 \
-drive file="${FLASHDRIVE_LOCATION}",format=qcow,if=none,media=disk,index=1,id=drive-hd1,readonly=on \
-device scsi-hd,bus=scsi0.0,drive=drive-hd1,id=hd1,bootindex=1 \
-boot menu=on \
-netdev user,id=net0,net="${IPV4_NETWORK}",dhcpstart="${IPV4_DHCP_FIRST_ADDR}",hostfwd=tcp::"${P22_FWD}"-:22 \
-device virtio-net-pci,netdev=net0 \
-rtc base=localtime,clock=vm \
-device virtio-vga-gl \
-display gtk,gl=on \
-monitor stdio \
-name "${VM_NAME}"
