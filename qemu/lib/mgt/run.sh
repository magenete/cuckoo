#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Run ENV check
qemu_run_check_env()
{
    if [ -z "$QEMU_SYSTEM" ]
    then
        QEMU_RUN_DIR="$QEMU_BIN_ARCH_OS_VERSION_DIR"
    else
        QEMU_RUN_DIR="$QEMU_BIN_DIR"
    fi

    if [ -z "$QEMU_BIN_ARCH_OS_VERSION" ]
    then
        qemu_error "QEMU version was not defined" "Please check file '${QEMU_BIN_ARCH_OS_VERSION_FILE}'"
    fi

    if [ ! -d "$QEMU_RUN_DIR" ]
    then
        qemu_error "Directory '${QEMU_RUN_DIR}' does not exist"
    fi

    if [ ! -f "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
    then
        qemu_error "File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
    fi

    if [ ! -d "$QEMU_HD_DIR" ]
    then
        qemu_error "Directory '${QEMU_HD_DIR}' does not exist for HD"
    fi
}


# Copy in TMP_DIR if can not run
qemu_run_copy_in_tmp()
{
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
                chmod -R 0700 "$QEMU_RUN_DIR"

                if [ ! -x "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
                then
                    qemu_error "File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist for running"
                fi
            else
                qemu_error "Directory '${QEMU_TMP_DIR}${QEMU_BIN_ARCH_OS_VERSION}/' does not exist"
            fi
        else
            qemu_error "Directory '${QEMU_TMP_DIR}' does not exist"
        fi
    fi
}


# Option definition
qemu_run_define_options()
{
    # Bootloading (hd, cdrom, floppy)
    QEMU_OPTS="-boot order="
    if [ -z "$QEMU_CDROM_BOOT_FILE" ] && [ -z "$QEMU_FLOPPY_BOOT_FILE" ]
    then
        QEMU_OPTS="${QEMU_OPTS}c"
    else
        if [ ! -z "$QEMU_CDROM_BOOT_FILE" ]
        then
            if [ -f "$QEMU_CDROM_BOOT_FILE" ]
            then
                QEMU_OPTS="${QEMU_OPTS}d -cdrom ${QEMU_CDROM_BOOT_FILE}"
            else
                qemu_error "ISO file '${QEMU_CDROM_BOOT_FILE}' does not exist for CDROM"
            fi
        fi

        if [ ! -z "$QEMU_FLOPPY_BOOT_FILE" ]
        then
            if [ -f "$QEMU_FLOPPY_BOOT_FILE" ]
            then
                QEMU_OPTS="${QEMU_OPTS}a -fda ${QEMU_FLOPPY_BOOT_FILE}"
            else
                qemu_error "ISO file '${QEMU_FLOPPY_BOOT_FILE}' does not exist for Floppy Disk"
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
    if [ ! -z "$QEMU_CDROM_ADD_FILE" ]
    then
        QEMU_OPTS="${QEMU_OPTS} -drive media=cdrom,if=${QEMU_HD_TYPE},id=cdrom-1,index=-1,file=${QEMU_CDROM_ADD_FILE}"
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
}


# Run
qemu_run()
{
    qemu_run_check_env
    qemu_run_copy_in_tmp
    qemu_run_define_options

    "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" -name "$QEMU_TITLE" ${QEMU_OPTS}
}
