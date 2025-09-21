#!/bin/bash

source './env-vars.sh'

echo "Creating qcow2 main disk '${DISK_LOCATION}' with ${DISK_SIZE}"
qemu-img create -f raw "${DISK_LOCATION}" "${DISK_SIZE}"
