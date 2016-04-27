#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


QEMU_SYSTEM="$VIRT_EMULATOR_SYSTEM"
QEMU_HD_TYPE="$CUCKOO_HD_TYPE"
QEMU_CPU_CORES=$CUCKOO_CPU_CORES
QEMU_CPU_THREADS=$CUCKOO_CPU_THREADS
QEMU_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS
QEMU_SMB_DIR="$CUCKOO_SMB_DIR"
QEMU_FULL_SCREEN="$CUCKOO_FULL_SCREEN"
QEMU_DAEMONIZE_NO="$CUCKOO_DAEMONIZE_NO"
QEMU_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE"

QEMU_BOOT_CDROM_FILE="$CUCKOO_BOOT_CDROM_FILE"
QEMU_BOOT_FLOPPY_FILE="$CUCKOO_BOOT_FLOPPY_FILE"
QEMU_ADD_CDROM_FILE="$CUCKOO_ADD_CDROM_FILE"
QEMU_HD_DIR="${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
QEMU_TITLE=" Cuckoo -- ${CUCKOO_OS}[${CUCKOO_ARCH}] on ${QEMU_OS}[${QEMU_ARCH}] "
QEMU_OPTS_EXT="$CUCKOO_OPTS_EXT"
