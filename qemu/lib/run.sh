#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


. "${QEMU_DIR}lib/var.sh"


if [ -z "$QEMU_SYSTEM" ]
then
    QEMU_RUN_DIR="$QEMU_BIN_ARCH_OS_VERSION_DIR"
else
    QEMU_RUN_DIR="$QEMU_BIN_DIR"
fi


##  ENV check
if [ -z "$QEMU_BIN_ARCH_OS_VERSION" ]
then
    echo "ERROR: QEMU version was not defined"
    echo "Please check file '${QEMU_BIN_ARCH_OS_VERSION_FILE}'"
    exit 1
fi

if [ ! -d "$QEMU_RUN_DIR" ]
then
    echo "ERROR: Directory '${QEMU_RUN_DIR}' does not exist"
    exit 1
fi

if [ ! -f "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
then
    echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
    exit 1
fi

if [ ! -d "$QEMU_HD_DIR" ]
then
    echo "ERROR: Directory '${QEMU_HD_DIR}' does not exist for HD"
    exit 1
fi


##  Copy in TMP_DIR
"${QEMU_RUN_DIR}${QEMU_BIN_FILE}" -version > /dev/null
if [ $? -gt 0 ]
then
    mkdir -p "$QEMU_TMP_DIR"

    if [ -d "$QEMU_TMP_DIR" ]
    then
        cp -rf "$QEMU_RUN_DIR" "$QEMU_TMP_DIR"

        if [ -d "${QEMU_TMP_DIR}${QEMU_BIN_ARCH_OS_VERSION}/" ]
        then
            QEMU_RUN_DIR="${QEMU_TMP_DIR}${QEMU_BIN_ARCH_OS_VERSION}/"
            chmod -R 755 "$QEMU_RUN_DIR"

            if [ ! -x "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
            then
                echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
                exit 1
            fi
        else
            echo "ERROR: Directory '${QEMU_TMP_DIR}${QEMU_BIN_ARCH_OS_VERSION}/' does not exist"
            exit 1
        fi
    else
        echo "ERROR: Directory '${QEMU_TMP_DIR}' does not exist"
        exit 1
    fi
fi


##  QEMU option definition

# Bootloading (hd, cdrom, floppy)
QEMU_OPTS="-boot order="
if [ -z "$QEMU_BOOT_CDROM_FILE" ] && [ -z "$QEMU_BOOT_FLOPPY_FILE" ]
then
    QEMU_OPTS="${QEMU_OPTS}c"
else
    if [ ! -z "$QEMU_BOOT_CDROM_FILE" ]
    then
        if [ -e "$QEMU_BOOT_CDROM_FILE" ] && [ -f "$QEMU_BOOT_CDROM_FILE" ]
        then
            QEMU_OPTS="${QEMU_OPTS}d -cdrom ${QEMU_BOOT_CDROM_FILE}"
        else
            echo "ERROR: ISO file '${QEMU_BOOT_CDROM_FILE}' does not exist for CDROM"
            exit 1
        fi
    fi

    if [ ! -z "$QEMU_BOOT_FLOPPY_FILE" ]
    then
        if [ -e "$QEMU_BOOT_FLOPPY_FILE" ] && [ -f "$QEMU_BOOT_FLOPPY_FILE" ]
        then
            QEMU_OPTS="${QEMU_OPTS}a -fda ${QEMU_BOOT_FLOPPY_FILE}"
        else
            echo "ERROR: ISO file '${QEMU_BOOT_FLOPPY_FILE}' does not exist for Floppy Disk"
            exit 1
        fi
    fi
fi

# Memory
QEMU_OPTS="${QEMU_OPTS} -m ${QEMU_MEMORY_SIZE} -balloon virtio"

# CPU
QEMU_OPTS="${QEMU_OPTS} -cpu ${QEMU_CPU_MODEL} -smp cpus=$((${QEMU_CPU_CORES}*${QEMU_CPU_THREADS}*${QEMU_CPU_SOCKETS})),cores=${QEMU_CPU_CORES},threads=${QEMU_CPU_THREADS},sockets=${QEMU_CPU_SOCKETS}"

# Drive
for qemu_disk in $(ls $QEMU_HD_DIR)
do
    if [ -f "${QEMU_HD_DIR}${qemu_disk}" ]
    then
        QEMU_OPTS="${QEMU_OPTS} -drive media=disk,if=${QEMU_HD_TYPE},id=hd${qemu_disk},index=${qemu_disk},file=${QEMU_HD_DIR}${qemu_disk}"
    fi
done

# CDROM add
if [ ! -z "$QEMU_ADD_CDROM_FILE" ]
then
    QEMU_OPTS="${QEMU_OPTS} -drive media=cdrom,if=${QEMU_HD_TYPE},id=cdrom-1,index=-1,file=${QEMU_ADD_CDROM_FILE}"
fi

# Screen
QEMU_OPTS="${QEMU_OPTS} -vga std -sdl -display sdl"

# USB
QEMU_OPTS="${QEMU_OPTS} -usb -usbdevice tablet"
# -device piix3-usb-uhci"

# SMB directory
if [ ! -z "$QEMU_SMB_DIR" ]
then
    QEMU_OPTS="${QEMU_OPTS} -net nic -net user,smb=${QEMU_SMB_DIR}"
fi

# Full screen
if [ ! -z "$QEMU_FULL_SCREEN" ]
then
    QEMU_OPTS="${QEMU_OPTS} -full-screen"
fi

# KVM
if [ -z "$QEMU_ENABLE_KVM_NO" ]
then
    QEMU_OPTS="${QEMU_OPTS} -enable-kvm"
fi

# Daemonize
if [ -z "$QEMU_DAEMONIZE_NO" ]
then
    QEMU_OPTS="${QEMU_OPTS} -daemonize"
fi

# External(other) options
if [ ! -z "$QEMU_OPTS_EXT" ]
then
    QEMU_OPTS="${QEMU_OPTS} ${QEMU_OPTS_EXT}"
fi


##  QEMU run
"${QEMU_RUN_DIR}${QEMU_BIN_FILE}" -name "$QEMU_TITLE" ${QEMU_OPTS}
