#!/bin/bash

source './env-vars.sh'

echo "Creating qcow2 flashdrive '${FLASHDRIVE_LOCATION}' disk with ${FLASHDRIVE_SIZE}"
qemu-img create -f qcow2 "${FLASHDRIVE_LOCATION}" "${FLASHDRIVE_SIZE}"
virt-format -a "${FLASHDRIVE_LOCATION}" --partition=gpt --filesystem=ext4
