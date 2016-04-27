#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


VIRT_EMULATOR_SYSTEM=""
VIRT_EMULATOR_LIST="qemu"
VIRT_EMULATOR_DEFAULT="qemu"
VIRT_EMULATOR=""


CUCKOO_ACTION=""
CUCKOO_ACTION_DEFAULT="run"
CUCKOO_ACTION_ARCH_LIST=""
CUCKOO_ACTION_OS_LIST=""
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")/.." && pwd -P)}/"
CUCKOO_OS_LIST="linux netbsd freebsd openbsd macosx windows"
CUCKOO_OS_DEFAULT="linux"
CUCKOO_OS=""
CUCKOO_ARCH_LIST="x86 x86_64"
CUCKOO_ARCH=""
CUCKOO_DIST_VERSION_DEFAULT="debian/8.4"
CUCKOO_DIST_VERSION=""
CUCKOO_ISO_FILE=""
CUCKOO_ISO_FILE_NET=""
CUCKOO_ISO_FILE_PATH=""
CUCKOO_MEMORY_SIZE=""
CUCKOO_MEMORY_SIZE_DEFAULT="1G"
CUCKOO_CPU_MIN=1
CUCKOO_CPU_CORES=
CUCKOO_CPU_CORES_DEFAULT=4
CUCKOO_CPU_CORES_MAX=16
CUCKOO_CPU_THREADS=
CUCKOO_CPU_THREADS_DEFAULT=2
CUCKOO_CPU_THREADS_MAX=16
CUCKOO_CPU_SOCKETS=
CUCKOO_CPU_SOCKETS_DEFAULT=$CUCKOO_CPU_MIN
CUCKOO_CPU_SOCKETS_MAX=4
CUCKOO_SETUP_DIR=""
CUCKOO_BOOT_CDROM_FILE=""
CUCKOO_BOOT_FLOPPY_FILE=""
CUCKOO_ADD_CDROM_FILE=""
CUCKOO_FULL_SCREEN=""
CUCKOO_DAEMONIZE_NO=""
CUCKOO_HD_TYPE_LIST="ide, scsi, virtio"
CUCKOO_HD_TYPE=""
CUCKOO_HD_TYPE_DEFAULT="virtio"
CUCKOO_DIST_VERSION_CONFIG=""
CUCKOO_DIST_VERSION_CONFIG_FILE=""


QEMU_ACTION=""
QEMU_ACTION_DEFAULT="run"
QEMU_ACTION_ARCH_LIST=""
QEMU_ACTION_OS_LIST=""
QEMU_DIR="${QEMU_DIR:=${CUCKOO_DIR}../qemu}/"
QEMU_OS_LIST="linux macosx windows"
QEMU_OS=""
QEMU_ARCH_LIST="x86 x86_64"
QEMU_ARCH=""


# Help message definition
help_message()
{
    cat << _H_E_L_P

Usage: $(basename $0) [actions] [argumets]

  Actions:

    -s, --setup          Set directory with full path and setup Cuckoo.
    -b, --qemu-build     Build(only on Linux) QEMU for OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -q, --qemu-remove    Remove QEMU file(s).
    -u, --iso-url        Download ISO file and setup in Cuckoo.
    -f, --iso-file       Local copy ISO file and setup in Cuckoo.
    -I, --iso-remove     Remove ISO file(s).
    -H, --hd-remove      Remove QEMU HD(s).
    -i, --install        Install OS on QEMU image(s).
    -r, --run            Run QEMU (by default).
    -l, --iso-list       Get list of existing ISO files.
    -L, --hd-list        Get list of existing HD(s) files.

    -v, --version        Print the current version.
    -h, --help           Show this message.

  Arguments:

    -Q, --qemu-system    Run system QEMU.
    -A, --qemu-arch      Set QEMU architecture (by default: definition by OS).
                           QEMU architecture: $(from_arr_to_str "$QEMU_ARCH_LIST").
    -O, --qemu-os-name   Set QEMU OS (by default: definition by OS).
                           QEMU OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -a, --arch           Set OS architecture (by default: definition by OS).
                           OS architecture: $(from_arr_to_str "$CUCKOO_ARCH_LIST").
    -o, --os-name        Set OS name (by default: ${CUCKOO_OS_DEFAULT}).
                           OS: $(from_arr_to_str "$CUCKOO_OS_LIST").
    -d, --dist-version   Set dist and(or) version (by default: ${CUCKOO_DIST_VERSION_DEFAULT}).
    -E, --config-set     Create and write config file if --dist-version defined.
    -U, --config-update  Update config file if config file exists.
    -R, --config-remove  Remove config file if config file exists.
    -c, --boot-cdrom     Set file with full path for CDROM (IDE device).
    -p, --boot-floppy    Set file with full path for Floppy Disk.
    -D, --cdrom-add      Set file with full path for CDROM (by default: ${CUCKOO_HD_TYPE_DEFAULT}).
    -C, --cpu-cores      Set CPU cores (by default: ${CUCKOO_CPU_CORES_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_CORES_MAX}).
    -T, --cpu-threads    Set CPU threads (by default: ${CUCKOO_CPU_THREADS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_THREADS_MAX}).
    -S, --cpu-sockets    Set CPU sockets (by default: ${CUCKOO_CPU_SOCKETS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_SOCKETS_MAX}).
    -m, --memory-size    Set memory size (by default: ${CUCKOO_MEMORY_SIZE_DEFAULT}).
    -e, --smb-dir        Set directory with full path for SMB share.
    -F, --full-screen    Set full screen.
    -N, --no-daemonize   Running no daemonize.
    -t, --hd-type        Set hard drive type (by default: ${CUCKOO_HD_TYPE_DEFAULT}).
                           HD type: ${CUCKOO_HD_TYPE_LIST}.
    -P, --opts-add       Add other QEMU options.

_H_E_L_P
}


# Print error message and exit
error_message()
{
    help_message

    echo ""
    echo "ERROR: $1"
    echo ""

    exit 1
}


# Convert from Array to String
from_arr_to_str()
{
    str=""

    for char in $1
    do
        if [ -z "$str" ]
        then
            str="$char"
        else
            str="${str}, ${char}"
        fi
    done

    echo "$str"
}


##  Setup

# ISO files copying
cuckoo_iso_setup_copying()
{
    CUCKOO_ENV_NO="yes"

    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_ARCH="$cuckoo_arch"
                CUCKOO_OS="$cuckoo_os"

                . "${CUCKOO_DIR}lib/var.sh"

                if [ -e "$CUCKOO_ISO_ARCH_OS_DIR" ] && [ -d "$CUCKOO_ISO_ARCH_OS_DIR" ]
                then
                    mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/"
                    cp -rv "$CUCKOO_ISO_ARCH_OS_DIR" "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/"

                    echo "      ...from '${CUCKOO_ISO_ARCH_OS_DIR}'"
                else
                    echo "      WARNING: ISO file(s) has not been copyed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/"
            cp -rv "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"

            echo "      ...from '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -e "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ] && [ -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ]
            then
                mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
                cp -v "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" "${CUCKOO_SETUP_DIR}cuckoo/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_ISO_FILE}"

                echo "      ...from '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}'"
            else
                echo "      WARNING: ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' has not been copyed"
            fi
        fi
    fi
}

# HD(s) files copying
cuckoo_hd_setup_copying()
{
    CUCKOO_ENV_NO="yes"

    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_ARCH="$cuckoo_arch"
                CUCKOO_OS="$cuckoo_os"

                . "${CUCKOO_DIR}lib/var.sh"

                if [ -e "$CUCKOO_HD_ARCH_OS_DIR" ] && [ -d "$CUCKOO_HD_ARCH_OS_DIR" ]
                then
                    mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/"
                    cp -rv "$CUCKOO_HD_ARCH_OS_DIR" "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/"

                    echo "      ...from '${CUCKOO_HD_ARCH_OS_DIR}'"
                else
                    echo "      WARNING: HD(s) has not been copyed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            mkdir -p "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
            cp -rv "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/${CUCKOO_OS}/$(dirname ${CUCKOO_DIST_VERSION_DIR})"

            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
            then
                cp -v "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" "$(dirname "${CUCKOO_SETUP_DIR}cuckoo/hd/${CUCKOO_ARCH}/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}")"
            fi

            echo "      ...from '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            echo "      WARNING: HD(s) has not been copyed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
        fi
    fi
}

# QEMU copy
cuckoo_qemu_copy()
{
    QEMU_ENV_NO="yes"

    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_OS="$qemu_os"
            QEMU_ARCH="$qemu_arch"

            . "${QEMU_DIR}lib/var.sh"

            if [ ! -z "$QEMU_BIN_ARCH_OS_DIR" ] && [ -e "$QEMU_BIN_ARCH_OS_DIR" ] && [ -d "$QEMU_BIN_ARCH_OS_DIR" ]
            then
                mkdir "${CUCKOO_SETUP_DIR}qemu/bin/${QEMU_ARCH}/"
                cp -rv "$QEMU_BIN_ARCH_OS_DIR" "${CUCKOO_SETUP_DIR}qemu/bin/${QEMU_ARCH}/"

                echo "      ...from '${QEMU_BIN_ARCH_OS_DIR}'"
            else
                echo "WARNING: QEMU has not been copyed for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done
}


##  Setup
cuckoo_setup()
{
    CUCKOO_SETUP_DIR="${CUCKOO_SETUP_DIR}cuckoo/"
    CUCKOO_ENV_NO="yes"

    mkdir -p "$CUCKOO_SETUP_DIR"
    echo ""

    echo "  Main file: copying..."
    cp -v "${CUCKOO_DIR}../cuckoo.sh" "$CUCKOO_SETUP_DIR"
    cp -v "${CUCKOO_DIR}../cuckoo.bat" "$CUCKOO_SETUP_DIR"
    cp -v "${CUCKOO_DIR}../README.md" "$CUCKOO_SETUP_DIR"
    cp -v "${CUCKOO_DIR}../LICENSE" "$CUCKOO_SETUP_DIR"

    echo ""

    # Cuckoo
    echo "  Directory cuckoo/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory bin/: copying..."
    cp -rv "${CUCKOO_DIR}bin/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory etc/: copying..."
    cp -rv "${CUCKOO_DIR}etc/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory lib/: copying..."
    cp -rv "${CUCKOO_DIR}lib/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    Directory os/: copying..."
    cp -rv "${CUCKOO_DIR}os/" "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""
    echo "    ISO structure from iso/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}cuckoo/iso/"
    cuckoo_iso_setup_copying

    echo ""
    echo "    HD(s) structure from hd/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}cuckoo/hd/"
    cuckoo_hd_setup_copying

    echo ""
    echo "    Management and installation files: copying..."
    cp -v $(ls "${CUCKOO_DIR}"*.bat) "${CUCKOO_SETUP_DIR}cuckoo/"
    cp -v $(ls "${CUCKOO_DIR}"*.sh) "${CUCKOO_SETUP_DIR}cuckoo/"

    echo ""

    # QEMU
    echo ""
    echo "  Directory qemu/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}qemu/"

    echo ""
    echo "    Directory lib/: copying..."
    cp -rv "${QEMU_DIR}lib/" "${CUCKOO_SETUP_DIR}qemu/"

    echo ""
    echo "    Directory build/: copying..."
    cp -rv "${QEMU_DIR}build/" "${CUCKOO_SETUP_DIR}qemu/"

    echo ""
    echo "    Directory bin/: copying..."
    mkdir "${CUCKOO_SETUP_DIR}qemu/bin/"
    cuckoo_qemu_copy

    echo ""

    echo ""
    echo "Cuckoo has been setuped in '${CUCKOO_SETUP_DIR}'"
    echo ""
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

            if [ -e "$QEMU_BUILD_ARCH_OS_FILE" ] && [ -f "$QEMU_BUILD_ARCH_OS_FILE" ]
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


# QEMU remove
qemu_remove()
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

            if [ ! -z "$QEMU_BIN_ARCH_OS_VERSION_DIR" ] && [ -e "$QEMU_BIN_ARCH_OS_VERSION_DIR" ] && [ -d "$QEMU_BIN_ARCH_OS_VERSION_DIR" ]
            then
                rm -rf "$QEMU_BIN_ARCH_OS_VERSION_DIR"

                echo "QEMU has been removed in '${QEMU_BIN_ARCH_OS_DIR}'"
            else
                echo "WARNING: QEMU has not been removed for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done
    echo ""
}


# ISO file setup
cuckoo_iso_setup()
{
    CUCKOO_ENV_NO="yes"

    . "${CUCKOO_DIR}lib/var.sh"

    CUCKOO_ISO_FILE_SYS_PATH="${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"
    CUCKOO_ISO_FILE_DIR="$(dirname "$CUCKOO_ISO_FILE_SYS_PATH")/"
    CUCKOO_ISO_FILE="$(basename "$CUCKOO_ISO_FILE_SYS_PATH")"

    mkdir -p "${CUCKOO_ISO_FILE_DIR}"

    if [ -z "$CUCKOO_ISO_FILE_NET" ]
    then
        cp -f "$CUCKOO_ISO_FILE_PATH" "$CUCKOO_ISO_FILE_SYS_PATH"
    else
        curl -SL -o "$CUCKOO_ISO_FILE_SYS_PATH" "$CUCKOO_ISO_FILE_PATH"
    fi

    echo ""
    echo "ISO file has been setuped as '${CUCKOO_ISO_FILE_SYS_PATH}'"
    echo ""
}


# ISO files remove
cuckoo_iso_remove()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_OS="$cuckoo_os"
                CUCKOO_ARCH="$cuckoo_arch"

                . "${CUCKOO_DIR}lib/var.sh"

                if [ -e "$CUCKOO_ISO_ARCH_OS_DIR" ] && [ -d "$CUCKOO_ISO_ARCH_OS_DIR" ]
                then
                    rm -rf "$CUCKOO_ISO_ARCH_OS_DIR"
                    mkdir "$CUCKOO_ISO_ARCH_OS_DIR"

                    echo "ISO file(s) has been removed in '${CUCKOO_ISO_ARCH_OS_DIR}'"
                else
                    echo "WARNING: ISO file(s) has not been removed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

            echo "ISO file(s) has been removed in '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -e "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ] && [ -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}" ]
            then
                rm -f "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"

                echo "ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' has been removed"
            else
                echo "WARNING: ISO file '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}' has not been removed"
            fi
        fi
    fi
    echo ""
}


# QEMU HD(s) remove
cuckoo_hd_remove()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
        do
            for cuckoo_os in $CUCKOO_ACTION_OS_LIST
            do
                CUCKOO_OS="$cuckoo_os"
                CUCKOO_ARCH="$cuckoo_arch"

                . "${CUCKOO_DIR}lib/var.sh"

                if [ -e "$CUCKOO_HD_ARCH_OS_DIR" ] && [ -d "$CUCKOO_HD_ARCH_OS_DIR" ]
                then
                    rm -rf "$CUCKOO_HD_ARCH_OS_DIR"
                    mkdir "$CUCKOO_HD_ARCH_OS_DIR"

                    echo "HD(s) has been removed in directory '${CUCKOO_HD_ARCH_OS_DIR}'"
                else
                    echo "WARNING: HD(s) has not been removed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_ARCH="$CUCKOO_ACTION_ARCH_LIST"
        CUCKOO_OS="$CUCKOO_ACTION_OS_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
            cuckoo_dist_version_config_remove

            echo "HD(s) has been removed in directory '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}" ]
            then
                rm -f "${CUCKOO_HD_ARCH_OS_DIR}"
                cuckoo_dist_version_config_remove

                echo "HD(s) directory '${CUCKOO_HD_ARCH_OS_DIR}' has been removed"
            else
                echo "WARNING: HD(s) has been removed in directory '${CUCKOO_HD_ARCH_OS_DIR}'"
            fi
        fi
    fi
    echo ""
}


## ISO list
cuckoo_iso_list()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
    do
        for cuckoo_os in $CUCKOO_ACTION_OS_LIST
        do
            CUCKOO_OS="$cuckoo_os"
            CUCKOO_ARCH="$cuckoo_arch"

            cuckoo_dist_version="$CUCKOO_DIST_VERSION"

            . "${CUCKOO_DIR}lib/var.sh"

            if [ -z "$cuckoo_dist_version" ]
            then
                CUCKOO_DIST_VERSION=""
                CUCKOO_DIST_VERSION_DIR=""
            fi

            if [ -e "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
            then
                echo "ISO file(s) has been found in '${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}':"

                for iso_file in $(ls -R -h -x --file-type "${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" 2> /dev/null)
                do
                    echo "    $iso_file"
                done

                echo ""
            else
                echo "WARNING: ISO file(s) has not been found for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                echo ""
            fi
        done
    done
}


## HD(s) list
cuckoo_hd_list()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    for cuckoo_arch in $CUCKOO_ACTION_ARCH_LIST
    do
        for cuckoo_os in $CUCKOO_ACTION_OS_LIST
        do
            CUCKOO_ARCH="$cuckoo_arch"
            CUCKOO_OS="$cuckoo_os"

            cuckoo_dist_version="$CUCKOO_DIST_VERSION"

            . "${CUCKOO_DIR}lib/var.sh"

            if [ -z "$cuckoo_dist_version" ]
            then
                CUCKOO_DIST_VERSION=""
                CUCKOO_DIST_VERSION_DIR=""
            fi

            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
            then
                echo "HD file(s) has been found in '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}':"

                for hd_file in $(ls -R -h -x --file-type "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" 2> /dev/null)
                do
                    echo "    $hd_file"
                done

                echo ""
            else
                echo "WARNING: HD file(s) has not been found for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                echo ""
            fi
        done
    done
}


## Checking and default values

# QEMU
checking_and_default_qemu_values()
{
    [ -z "$QEMU_ACTION" ] && QEMU_ACTION="$QEMU_ACTION_DEFAULT"

    if [ "$QEMU_ACTION" = "build" ] || [ "$QEMU_ACTION" = "remove" ] || [ "$QEMU_ACTION" = "copy" ]
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

# All
checking_and_default_values()
{
    # Emulator
    [ -z "$VIRT_EMULATOR" ] && VIRT_EMULATOR="$VIRT_EMULATOR_DEFAULT"

    checking_and_default_qemu_values

    # Cuckoo
    [ -z "$CUCKOO_ACTION" ] && CUCKOO_ACTION="$CUCKOO_ACTION_DEFAULT"

    if [ "$CUCKOO_ACTION" = "run" ] || [ "$CUCKOO_ACTION" = "install" ]
    then
        [ -z "$CUCKOO_OS" ] && CUCKOO_OS="$CUCKOO_OS_DEFAULT"
        [ -z "$CUCKOO_DIST_VERSION" ] && CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION_DEFAULT"

        if [ -z "$CUCKOO_ARCH" ]
        then
            . "${CUCKOO_DIR}lib/env.sh"
            CUCKOO_ARCH="$CUCKOO_ARCH"
        fi

        if [ -z "$CUCKOO_CPU_CORES" ]
        then
            if [ "$CUCKOO_ARCH" = "x86" ]
            then
                CUCKOO_CPU_CORES=$((CUCKOO_CPU_CORES_DEFAULT/2))
            else
                CUCKOO_CPU_CORES=$CUCKOO_CPU_CORES_DEFAULT
            fi
        fi

        [ -z "$CUCKOO_CPU_THREADS" ] && CUCKOO_CPU_THREADS=$CUCKOO_CPU_THREADS_DEFAULT
        [ -z "$CUCKOO_CPU_SOCKETS" ] && CUCKOO_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS_DEFAULT
        [ -z "$CUCKOO_HD_TYPE" ] && CUCKOO_HD_TYPE="$CUCKOO_HD_TYPE_DEFAULT"
        [ -z "$CUCKOO_MEMORY_SIZE" ] && CUCKOO_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE_DEFAULT"
    else
        if [ -z "$CUCKOO_OS" ]
        then
            if [ -z "$CUCKOO_DIST_VERSION" ]
            then
                CUCKOO_ACTION_OS_LIST="$CUCKOO_OS_LIST"
            else
                CUCKOO_ACTION_OS_LIST="$CUCKOO_OS_DEFAULT"
            fi
        else
            CUCKOO_ACTION_OS_LIST="$CUCKOO_OS"
        fi

        if [ -z "$CUCKOO_ARCH" ]
        then
            if [ -z "$CUCKOO_DIST_VERSION" ]
            then
                CUCKOO_ACTION_ARCH_LIST="$CUCKOO_ARCH_LIST"
            else
                . "${CUCKOO_DIR}lib/env.sh"
                CUCKOO_ACTION_ARCH_LIST="$CUCKOO_ARCH"
            fi
        else
            CUCKOO_ACTION_ARCH_LIST="$CUCKOO_ARCH"
        fi
    fi
}


## Config management for distributive/version

# Create
cuckoo_dist_version_config_create()
{
    cat > "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" << _C_O_F_I_G
CUCKOO_OS="$CUCKOO_OS"
CUCKOO_ARCH="$CUCKOO_ARCH"
CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION"
CUCKOO_DIST_VERSION_DIR="$CUCKOO_DIST_VERSION_DIR"
CUCKOO_ISO_FILE="$CUCKOO_ISO_FILE"

CUCKOO_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE"
CUCKOO_CPU_CORES=$CUCKOO_CPU_CORES
CUCKOO_CPU_THREADS=$CUCKOO_CPU_THREADS
CUCKOO_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS
CUCKOO_HD_TYPE="$CUCKOO_HD_TYPE"
CUCKOO_FULL_SCREEN="$CUCKOO_FULL_SCREEN"
CUCKOO_DAEMONIZE_NO="$CUCKOO_DAEMONIZE_NO"
CUCKOO_SMB_DIR="$CUCKOO_SMB_DIR"

CUCKOO_ADD_CDROM_FILE="$CUCKOO_ADD_CDROM_FILE"
CUCKOO_OPTS_EXT="$CUCKOO_OPTS_EXT"
_C_O_F_I_G
}

# Load
cuckoo_dist_version_config_load()
{
    if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
    then
        . "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}"
    fi
}

# Merge
cuckoo_dist_version_config_merge_var()
{
    CUCKOO_OS__C_O_N_F_I_G="$CUCKOO_OS"
    CUCKOO_ARCH__C_O_N_F_I_G="$CUCKOO_ARCH"
    CUCKOO_DIST_VERSION__C_O_N_F_I_G="$CUCKOO_DIST_VERSION"
    CUCKOO_DIST_VERSION_DIR__C_O_N_F_I_G="$CUCKOO_DIST_VERSION_DIR"
    CUCKOO_ISO_FILE__C_O_N_F_I_G="$CUCKOO_ISO_FILE"

    CUCKOO_MEMORY_SIZE__C_O_N_F_I_G="$CUCKOO_MEMORY_SIZE"
    CUCKOO_CPU_CORES__C_O_N_F_I_G=$CUCKOO_CPU_CORES
    CUCKOO_CPU_THREADS__C_O_N_F_I_G=$CUCKOO_CPU_THREADS
    CUCKOO_CPU_SOCKETS__C_O_N_F_I_G=$CUCKOO_CPU_SOCKETS
    CUCKOO_HD_TYPE__C_O_N_F_I_G="$CUCKOO_HD_TYPE"
    CUCKOO_FULL_SCREEN__C_O_N_F_I_G="$CUCKOO_FULL_SCREEN"
    CUCKOO_DAEMONIZE_NO__C_O_N_F_I_G="$CUCKOO_DAEMONIZE_NO"
    CUCKOO_SMB_DIR__C_O_N_F_I_G="$CUCKOO_SMB_DIR"

    CUCKOO_ADD_CDROM_FILE__C_O_N_F_I_G="$CUCKOO_ADD_CDROM_FILE"
    CUCKOO_OPTS_EXT__C_O_N_F_I_G="$CUCKOO_OPTS_EXT"

    cuckoo_dist_version_config_load

    [ "$CUCKOO_OS" != "$CUCKOO_OS__C_O_N_F_I_G" ] && CUCKOO_OS="$CUCKOO_OS__C_O_N_F_I_G"
    [ "$CUCKOO_ARCH" != "$CUCKOO_ARCH_CONFIG_TMP" ] && CUCKOO_ARCH="$CUCKOO_ARCH__C_O_N_F_I_G"
    [ "$CUCKOO_DIST_VERSION" != "$CUCKOO_DIST_VERSION__C_O_N_F_I_G" ] && CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION__C_O_N_F_I_G"
    [ "$CUCKOO_DIST_VERSION_DIR" != "$CUCKOO_DIST_VERSION_DIR__C_O_N_F_I_G" ] && CUCKOO_DIST_VERSION_DIR="$CUCKOO_DIST_VERSION_DIR__C_O_N_F_I_G"
    [ "$CUCKOO_ISO_FILE" != "$CUCKOO_ISO_FILE__C_O_N_F_I_G" ] && CUCKOO_ISO_FILE="$CUCKOO_ISO_FILE__C_O_N_F_I_G"

    [ "$CUCKOO_MEMORY_SIZE" != "$CUCKOO_MEMORY_SIZE__C_O_N_F_I_G" ] && CUCKOO_MEMORY_SIZE="$CUCKOO_MEMORY_SIZE__C_O_N_F_I_G"
    [ "$CUCKOO_CPU_CORES" != "$CUCKOO_CPU_CORES__C_O_N_F_I_G" ] && CUCKOO_CPU_CORES="$CUCKOO_CPU_CORES__C_O_N_F_I_G"
    [ "$CUCKOO_CPU_THREADS" != "$CUCKOO_CPU_THREADS__C_O_N_F_I_G" ] && CUCKOO_CPU_THREADS="$CUCKOO_CPU_THREADS__C_O_N_F_I_G"
    [ "$CUCKOO_CPU_SOCKETS" != "$CUCKOO_CPU_SOCKETS__C_O_N_F_I_G" ] && CUCKOO_CPU_SOCKETS="$CUCKOO_CPU_SOCKETS__C_O_N_F_I_G"
    [ "$CUCKOO_HD_TYPE" != "$CUCKOO_HD_TYPE__C_O_N_F_I_G" ] && CUCKOO_HD_TYPE="$CUCKOO_HD_TYPE__C_O_N_F_I_G"
    [ "$CUCKOO_FULL_SCREEN" != "$CUCKOO_FULL_SCREEN__C_O_N_F_I_G" ] && CUCKOO_FULL_SCREEN="$CUCKOO_FULL_SCREEN__C_O_N_F_I_G"
    [ "$CUCKOO_DAEMONIZE_NO" != "$CUCKOO_DAEMONIZE_NO__C_O_N_F_I_G" ] && CUCKOO_DAEMONIZE_NO="$CUCKOO_DAEMONIZE_NO__C_O_N_F_I_G"
    [ "$CUCKOO_SMB_DIR" != "$CUCKOO_SMB_DIR__C_O_N_F_I_G" ] && CUCKOO_SMB_DIR="$CUCKOO_SMB_DIR__C_O_N_F_I_G"

    [ "$CUCKOO_ADD_CDROM_FILE" != "$CUCKOO_ADD_CDROM_FILE__C_O_N_F_I_G" ] && CUCKOO_ADD_CDROM_FILE="$CUCKOO_ADD_CDROM_FILE__C_O_N_F_I_G"
    [ "$CUCKOO_OPTS_EXT" != "$CUCKOO_OPTS_EXT__C_O_N_F_I_G" ] && CUCKOO_OPTS_EXT="$CUCKOO_OPTS_EXT__C_O_N_F_I_G"
}

# Remove
cuckoo_dist_version_config_remove()
{
    if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
    then
        rm -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}"
    fi
}

# Manage
cuckoo_dist_version_config()
{
    case "$CUCKOO_DIST_VERSION_CONFIG" in
        set )
            cuckoo_dist_version_config_create
        ;;
        update )
            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_CONFIG_FILE}" ]
            then
                cuckoo_dist_version_config_merge_var
                cuckoo_dist_version_config_create
            fi
        ;;
        remove )
            cuckoo_dist_version_config_remove
        ;;
        * )
            cuckoo_dist_version_config_load
        ;;
    esac
}


##  Options definition
ARGS_SHORT="s:bqu:f:IHirlLQA:O:a:o:d:EURc:p:D:C:T:S:m:e:FNt:P:vh"
ARGS_LONG="setup:,qemu-build,qemu-remove,iso-url:,iso-file:,iso-remove,hd-remove,install,run,iso-list,hd-list,qemu-system,qemu-arch,qemu-os-name:,arch:,os-name:,dist-version:,config-set,config-update,config-remove,boot-cdrom:,boot-floppy:,cdrom-add:,cpu-cores:,cpu-threads:,cpu-sockets:,memory-size:,smb-dir:,full-screen,no-daemonize,hd-type:,opts-add:,version,help"
OPTS="$(getopt -o "${ARGS_SHORT}" -l "${ARGS_LONG}" -a -- "$@" 2>/dev/null)"
if [ $? -gt 0 ]
then
    error_message "Invalid option(s) value"
fi

eval set -- "$OPTS"

# Options parsing
while [ $# -gt 0 ]
do
    case $1 in
    -- )
        shift 1
    ;;
    --setup | -s )
        CUCKOO_ACTION="setup"
        if [ -e "$2" ] && [ -d "$2" ]
        then
            CUCKOO_SETUP_DIR="${2}/"
            QEMU_ACTION="copy"
        else
            error_message "Directory '$2' does not exist for setup"
        fi
        shift 2
    ;;
    --qemu-build | -b )
        QEMU_ACTION="build"
        shift 1
    ;;
    --qemu-remove | -q )
        QEMU_ACTION="remove"
        shift 1
    ;;
    --iso-url | -u )
        CUCKOO_ACTION="iso-setup"
        CUCKOO_ISO_FILE_PATH="$2"
        CUCKOO_ISO_FILE_NET="yes"
        shift 2
    ;;
    --iso-file | -f )
        CUCKOO_ACTION="iso-setup"
        if [ -e "$2" ] && [ -f "$2" ]
        then
            CUCKOO_ISO_FILE_PATH="$2"
            CUCKOO_ISO_FILE_NET=""
        else
            error_message "File ISO '$2' does not exist"
        fi
        shift 2
    ;;
    --iso-remove | -I )
        CUCKOO_ACTION="iso-remove"
        shift 1
    ;;
    --hd-remove | -H )
        CUCKOO_ACTION="hd-remove"
        shift 1
    ;;
    --install | -i )
        CUCKOO_ACTION="install"
        shift 1
    ;;
    --run | -r )
        CUCKOO_ACTION="run"
        shift 1
    ;;
    --iso-list | -l )
        CUCKOO_ACTION="iso-list"
        shift 1
    ;;
    --hd-list | -L )
        CUCKOO_ACTION="hd-list"
        shift 1
    ;;
    --qemu-system | -Q )
        QEMU_ACTION="run-system"
        shift 1
    ;;
    --qemu-arch | -A )
        case "$2" in
            x86 | x86_64 )  # See QEMU_ARCH_LIST
                QEMU_ARCH="$2"
            ;;
            * )
                error_message "QEMU architecture '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --qemu-os-name | -O )
        case "$2" in
            linux | macosx | windows )  # See QEMU_OS_LIST
                QEMU_OS="$2"
            ;;
            * )
                error_message "QEMU OS '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --arch | -a )
        case "$2" in
            x86 | x86_64 )  # See CUCKOO_ARCH_LIST
                CUCKOO_ARCH="$2"
            ;;
            * )
                error_message "OS architecture '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --os-name | -o )
        case "$2" in
            linux | netbsd | freebsd | openbsd | macosx | windows )  # See CUCKOO_OS_LIST
                CUCKOO_OS="$2"
            ;;
            * )
                error_message "OS '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --dist-version | -d )
        CUCKOO_DIST_VERSION="$2"
        shift 2
    ;;
    --config-set | -E )
        CUCKOO_DIST_VERSION_CONFIG="set"
        shift 1
    ;;
    --config-update | -U )
        CUCKOO_DIST_VERSION_CONFIG="update"
        shift 1
    ;;
    --config-remove | -R )
        CUCKOO_DIST_VERSION_CONFIG="remove"
        shift 1
    ;;
    --boot-cdrom | -c )
        if [ -e "$2" ] && [ -f "$2" ]
        then
            CUCKOO_BOOT_CDROM_FILE="$2"
        else
            error_message "File '$2' does not exist for CDROM"
        fi
        shift 2
    ;;
    --boot-floppy | -p )
        if [ -e "$2" ] && [ -f "$2" ]
        then
            CUCKOO_BOOT_FLOPPY_FILE="$2"
        else
            error_message "File '$2' does not exist for Floppy Disk"
        fi
        shift 2
    ;;
    --cdrom-add | -D )
        if [ -e "$2" ] && [ -f "$2" ]
        then
            CUCKOO_ADD_CDROM_FILE="$2"
        else
            error_message "File '$2' does not exist for CDROM(adding)"
        fi
        shift 2
    ;;
    --cpu-cores | -C )
        if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_CORES_MAX ]
        then
            CUCKOO_CPU_CORES=$2
        else
            error_message "Invalid value CPU cores '$2'"
        fi
        shift 2
    ;;
    --cpu-threads | -T )
        if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_THREADS_MAX ]
        then
            CUCKOO_CPU_THREADS=$2
        else
            error_message "Invalid value CPU threads '$2'"
        fi
        shift 2
    ;;
    --cpu-sockets | -S )
        if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_SOCKETS_MAX ]
        then
            CUCKOO_CPU_SOCKETS=$2
        else
            error_message "Invalid value CPU sockets '$2'"
        fi
        shift 2
    ;;
    --memory-size | -m )
        CUCKOO_MEMORY_SIZE="$2"
        shift 2
    ;;
    --smb-dir | -e )
        if [ -e "$2" ] && [ -d "$2" ]
        then
            CUCKOO_SMB_DIR="$2"
        else
            error_message "Directory '$2' does not exist for SMB"
        fi
        shift 2
    ;;
    --full-screen | -F )
        CUCKOO_FULL_SCREEN="yes"
        shift 1
    ;;
    --no-daemonize | -N )
        CUCKOO_DAEMONIZE_NO="yes"
        shift 1
    ;;
    --hd-type | -t )
        case "$2" in
            ide | scsi | virtio )
                CUCKOO_HD_TYPE="$2"
            ;;
            * )
                error_message "HD type '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --opts-add | -P )
        CUCKOO_OPTS_EXT="$2"
        shift 2
    ;;
    --version | -v )
        CUCKOO_ENV_NO="yes"

        . "${CUCKOO_DIR}lib/var.sh"

        echo "Cuckoo version: $(cat "${CUCKOO_ETC_VERSION_FILE}")"
        exit 0
    ;;
    --help | -h )
        help_message
        exit 0
    ;;
    * )
        error_message "Invalid option(s)"
    ;;
    esac
done


##  Values checking
checking_and_default_values


##  *ACTION running

# QEMU
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
            error_message "QEMU building only on Linux!"
        else
            qemu_build
        fi
    ;;
    remove )
        qemu_remove
    ;;
    copy )  # See common method cuckoo_setup()
    ;;
    * )
        error_message "QEMU action '${QEMU_ACTION}' does not supported"
    ;;
esac

# Cuckoo
case "$CUCKOO_ACTION" in
    run | install )
        case "$VIRT_EMULATOR" in
            qemu )
                if [ "$QEMU_ACTION" = "run" ] || [ "$QEMU_ACTION" = "run-system" ]
                then
                    [ "$QEMU_ACTION" = "run-system" ] && QEMU_ENV_NO="yes"

                    . "${CUCKOO_DIR}lib/var.sh"

                    [ "$QEMU_OS" != "linux" ] && QEMU_ENABLE_KVM_NO="yes"

                    cuckoo_dist_version_config

                    if [ "$CUCKOO_ACTION" = "install" ]
                    then
                        CUCKOO_BOOT_CDROM_FILE="${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"

                        if [ -e "$CUCKOO_BOOT_CDROM_FILE" ] && [ -f "$CUCKOO_BOOT_CDROM_FILE" ]
                        then
                            . "${CUCKOO_DIR}lib/hd.sh"
                        else
                            error_message "ISO file '$2' does not exist for installation"
                        fi
                    fi

                    . "${CUCKOO_DIR}lib/qemu.sh"
                    . "${QEMU_DIR}lib/run.sh"
                fi
            ;;
            * )
                error_message "QEMU action '${QEMU_ACTION}' does not supported"
            ;;
        esac
    ;;
    setup )
        cuckoo_setup
    ;;
    iso-setup )
        cuckoo_iso_setup
    ;;
    iso-remove )
        cuckoo_iso_remove
    ;;
    hd-remove )
        cuckoo_hd_remove
    ;;
    iso-list )
        cuckoo_iso_list
    ;;
    hd-list )
        cuckoo_hd_list
    ;;
    * )
        error_message "Cuckoo action '${CUCKOO_ACTION}' does not supported"
    ;;
esac
