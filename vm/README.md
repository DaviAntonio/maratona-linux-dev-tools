# Maratona Linux Development Scripts

## Setup

The scripts are flexible, but they still have requirements in order to be run.

### Packages

These scripts need the following packages to be installed on the host's system
(assuming a Debian GNU/Linux based distribution, such as Ubuntu, Linux Mint):

|Package         |Version|
|----------------|-------|
|qemu-system-x86 |7.0.0  |
|qemu-utils      |7.0.0  |
|qemu-system-gui |7.0.0  |
|qemu-block-extra|7.0.0  |
|ovmf            |2020.11|
|libguestfs-tools|1.44.0 |

The scripts assume that KVM-based accelerated virtualisation is enabled on the
host machine. This requires a compatible processor and it may require a
configuration in the UEFI/BIOS (AMD-V, AMD SVM, Intel VT, Intel VT-x,
Intel VMX).

The package `cpu-checker` is able to verify if KVM is correctly enabled: one
only needs to run the command `kvm-ok` as superuser.

### Expected directory structure

Even though these scripts can be modified easily, they expect the following
directory structure in their current form:

- `extracted-home.d`, a directory to store files removed from the icpc user's
home directory
- `packages`, a symbolic link to a directory of binary Debian packages (`*.deb`)
- `pull-from-vm`, a directory to store configuration files extracted from the
Virtual Machine's disk
- `push-to-home.d`, a directory to place files that will be sent to the home
directory of the icpc user
- `push-to-vm`, a directory to place configuration files
- `link-ubuntu-22.04-desktop-amd64.iso`, a symbolic link to a Ubuntu 22.04
installation disk

## Starting the Virtual Machine up for the first time

The initial images are created by the `reset-*` scripts

```
./reset-main-drive
./reset-flashdrive
```

With the drives created, run the initialisation script and install a regular
Ubuntu 22.04 LTS installation:

- Language and keyboard layout: English (US)
- Minimal installation
- Download updates while installing Ubuntu
- Erase disk and install Ubuntu
- Timezone: Sao Paulo

```
./first-boot
```

## Configuring a repository

Extract the files from the image

`./extract-repo-cfg.sh`

### Setting up automount

Modify the `fstab` file. In order to find the flashdrive's UUID, it needs to be
mounted and inspected using `guestfish`:

```
add flashdrive.qcow
run
blkid /dev/sda1
```

Append to the extracted file the following line, replacing the UUID entry with
the one found using guestfish:

```
# maratona packages drive
UUID=replace-by-your-uuid /mnt/maratona-packages ext4 defaults 0 2
```

### Configure apt

Modify the `sources.list` file extracted form the image. Append the following
lines to it:

```
# Local repository for Maratona Linux
deb [trusted=yes] file:/mnt/maratona-packages/packages ./
```
