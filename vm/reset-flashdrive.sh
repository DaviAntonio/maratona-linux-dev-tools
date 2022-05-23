#!/bin/bash

readonly DISK_SIZE="4G"
readonly FLASHDRIVE_DISK="flashdrive.qcow2"

echo "Creating qcow2 flashdrive '${FLASHDRIVE_DISK}' disk with ${DISK_SIZE}"
qemu-img create -f qcow2 "${FLASHDRIVE_DISK}" "${DISK_SIZE}"
virt-format -a "${FLASHDRIVE_DISK}" --partition=gpt --filesystem=ext4
