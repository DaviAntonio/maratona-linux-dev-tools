#!/bin/bash

readonly DISK_LOCATION="ubuntu-22.04-initial.qcow2"
readonly DISK_SIZE="30G"

echo "Creating qcow2 main disk '${DISK_LOCATION}' with ${DISK_SIZE}"
qemu-img create -f qcow2 "${DISK_LOCATION}" "${DISK_SIZE}"
