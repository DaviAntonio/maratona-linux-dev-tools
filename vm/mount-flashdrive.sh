#!/bin/bash

source './env-vars.sh'

guestmount -a "${FLASHDRIVE_LOCATION}" -m '/dev/sda1' '/mnt'
