#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Mapping Cuckoo variables for QEMU variables
cuckoo_qemu_mapping()
{
    QEMU_SYSTEM="$CUCKOO_EMULATOR_SYSTEM"
    QEMU_ARCH="$CUCKOO_EMULATOR_ARCH"
    QEMU_OS="$CUCKOO_EMULATOR_OS"
    QEMU_ACTION="$CUCKOO_EMULATOR_ACTION"
    QEMU_SETUP_DIR="$CUCKOO_EMULATOR_SETUP_DIR"
    QEMU_BUILD_BRANCH="$CUCKOO_EMULATOR_VERSION"
    QEMU_VERSION="$CUCKOO_EMULATOR_VERSION"

    QEMU_HD_TYPE="$CUCKOO_HD_TYPE"
    QEMU_CPU_CORES=$CUCKOO_CPU_CORES
    QEMU_CPU_THREADS=$CUCKOO_CPU_THREADS
    QEMU_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS
    QEMU_SMB_DIR="$CUCKOO_SMB_DIR"
    QEMU_FULL_SCREEN="$CUCKOO_FULL_SCREEN"
    QEMU_DAEMONIZE_NO="$CUCKOO_DAEMONIZE_NO"
    QEMU_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE"

    QEMU_CDROM_BOOT_FILE="$CUCKOO_CDROM_BOOT_FILE"
    QEMU_FLOPPY_BOOT_FILE="$CUCKOO_FLOPPY_BOOT_FILE"
    QEMU_CDROM_ADD_FILE="$CUCKOO_CDROM_ADD_FILE"
    QEMU_HD_DIR="${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

    QEMU_TITLE=" Cuckoo -- ${CUCKOO_OS}[${CUCKOO_ARCH}] on ${CUCKOO_EMULATOR_OS_REAL}[${CUCKOO_EMULATOR_ARCH_REAL}] "
    QEMU_OPTS_EXT="$CUCKOO_OPTS_EXT"
}


# QEMU initialize, libs load and mapping contstants
cuckoo_qemu_init()
{
    QEMU_DIR="${CUCKOO_DIR}../qemu"

    . "${QEMU_DIR}/lib/mgt.sh"


    QEMU_OS_REAL="yes"
    qemu_env

    CUCKOO_EMULATOR_ARCH_REAL="$QEMU_ARCH"
    CUCKOO_EMULATOR_OS_REAL="$QEMU_OS"

    QEMU_OS_REAL=""
    QEMU_ARCH=""
    QEMU_OS=""


    CUCKOO_EMULATOR_ARCH_LIST="${QEMU_ARCH_LIST} ${CUCKOO_EMULATOR_ARCH_LIST}"
    CUCKOO_EMULATOR_OS_LIST="${QEMU_OS_LIST} ${CUCKOO_EMULATOR_OS_LIST}"

    CUCKOO_EMULATOR_HD_TYPE_LIST="$QEMU_HD_TYPE_LIST"
    CUCKOO_EMULATOR_HD_TYPE_DEFAULT="$QEMU_HD_TYPE_DEFAULT"
}
