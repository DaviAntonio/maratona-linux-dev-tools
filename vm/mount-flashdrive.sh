#!/bin/bash

readonly FLASHDRIVE_LOCATION="flashdrive.qcow2"

guestmount -a "${FLASHDRIVE_LOCATION}" -m '/dev/sda1' '/mnt'
