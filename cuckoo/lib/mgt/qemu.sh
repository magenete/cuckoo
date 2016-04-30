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
}


# QEMU build
qemu_build()
{
    QEMU_ENV_NO="yes"

    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_ARCH="$qemu_arch"
            QEMU_OS="$qemu_os"

            . "${QEMU_DIR}lib/var.sh"

            if [ -f "$QEMU_BUILD_ARCH_OS_FILE" ]
            then
                . "$QEMU_BUILD_ARCH_OS_FILE"

                echo ""
                echo "QEMU has been builded in '${QEMU_BIN_ARCH_OS_VERSION_DIR}'"
                echo ""
            else
                echo ""
                echo "WARNING: QEMU has not been builded for OS: ${qemu_os}, arch: ${qemu_arch}"
                echo ""
            fi
        done
    done
}


# QEMU delete
qemu_delete()
{
    QEMU_ENV_NO="yes"

    echo ""
    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_ARCH="$qemu_arch"
            QEMU_OS="$qemu_os"

            . "${QEMU_DIR}lib/var.sh"

            if [ ! -z "$QEMU_BIN_ARCH_OS_VERSION_DIR" ] && [ -d "$QEMU_BIN_ARCH_OS_VERSION_DIR" ]
            then
                rm -rf "$QEMU_BIN_ARCH_OS_VERSION_DIR"

                echo "QEMU has been deleted in '${QEMU_BIN_ARCH_OS_DIR}'"
            else
                echo "WARNING: QEMU has not been deleted for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done
    echo ""
}


# QEMU variables check
qemu_variables_check()
{
    [ -z "$QEMU_ACTION" ] && QEMU_ACTION="$QEMU_ACTION_DEFAULT"

    if [ "$QEMU_ACTION" = "build" ] || [ "$QEMU_ACTION" = "delete" ] || [ "$QEMU_ACTION" = "copy" ]
    then
        if [ -z "$QEMU_OS" ]
        then
            QEMU_ACTION_OS_LIST="$QEMU_OS_LIST"
        else
            QEMU_ACTION_OS_LIST="$QEMU_OS"
        fi

        if [ -z "$QEMU_ARCH" ]
        then
            QEMU_ACTION_ARCH_LIST="$QEMU_ARCH_LIST"
        else
            QEMU_ACTION_ARCH_LIST="$QEMU_ARCH"
        fi
    fi
}


# QEMU actions
qemu_actions()
{
    case "$QEMU_ACTION" in
        run )
            QEMU_OS_REAL="yes"
            . "${QEMU_DIR}lib/env.sh"
        ;;
        run-system )
            VIRT_EMULATOR_SYSTEM="yes"
        ;;
        build )
            QEMU_OS_REAL="yes"
            . "${QEMU_DIR}lib/env.sh"
            QEMU_OS_REAL=""

            if [ "$QEMU_OS" != "linux" ]
            then
                cuckoo_error "QEMU building only on Linux!"
            else
                qemu_build
            fi
        ;;
        delete )
            qemu_delete
        ;;
        copy )  # See common method cuckoo_setup()
        ;;
        * )
            cuckoo_error "QEMU action '${QEMU_ACTION}' does not supported"
        ;;
    esac
}


# QEMU launch
cuckoo_qemu_launch()
{
    [ "$QEMU_ACTION" = "run-system" ] && QEMU_ENV_NO="yes"

    cuckoo_variables

    [ "$QEMU_OS" != "linux" ] && QEMU_ENABLE_KVM_NO="yes"

    if [ "$CUCKOO_ACTION" = "install" ]
    then
        CUCKOO_BOOT_CDROM_FILE="${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"

        if [ -f "$CUCKOO_BOOT_CDROM_FILE" ]
        then
            cuckoo_hd_create
        else
            cuckoo_error "ISO file '${2}' does not exist for installation"
        fi
    fi

    cuckoo_qemu_mapping

    . "${QEMU_DIR}lib/run.sh"
}


# QEMU run
qemu_run()
{
    if [ "$QEMU_ACTION" = "run" ] || [ "$QEMU_ACTION" = "run-system" ]
    then
        cuckoo_qemu_launch
    fi
}
