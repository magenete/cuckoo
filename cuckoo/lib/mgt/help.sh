#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Help message
cuckoo_help()
{
    CUCKOO_EMULATOR_NAME="${CUCKOO_EMULATOR_NAME:=$CUCKOO_EMULATOR_NAME_DEFAULT}"
    CUCKOO_EMULATOR="${CUCKOO_EMULATOR:=$CUCKOO_EMULATOR_DEFAULT}"

    cat << _H_E_L_P

Usage: $(basename $0) [actions] [arguments]

  Actions:

    -s, --setup           Set directory with full path and setup Cuckoo.
    -i, --install         Install OS on HD(s) (${CUCKOO_EMULATOR_NAME} image).
    -r, --run             Run emulator (by default: ${CUCKOO_EMULATOR_NAME_DEFAULT}).
    -b, --qemu-build      Build (only on Linux) ${CUCKOO_EMULATOR_NAME} for OS: $(from_arr_to_str "$CUCKOO_EMULATOR_OS_LIST").
    -I, --qemu-list       List existing ${CUCKOO_EMULATOR_NAME} versions.
    -V, --qemu-version    Set ${CUCKOO_EMULATOR_NAME} version.
    -q, --qemu-delete     Delete ${CUCKOO_EMULATOR_NAME} file(s).
    -d, --iso-download    Download ISO file and setup.
    -p, --iso-import      Copy ISO file locally and setup.
    -e, --iso-export      Export ISO file(s) in directory.
    -l, --iso-list        List existing ISO files.
    -x, --iso-delete      Delete ISO file(s).
    -D, --hd-download     Download HD tar (bz2) file and setup.
    -P, --hd-import       Copy HD directory or tar file locally and setup.
    -E, --hd-export       Export HD(s) in directory.
    -L, --hd-list         List existing HD(s) files.
    -X, --hd-delete       Delete HD(s).
    -W, --config-create   Create and write config file if --dist-version is defined.
    -U, --config-update   Update config file if exists.
    -Z, --config-delete   Delete config file if exists.
    -w, --desktop-create  Create and write desktop file if --dist-version is defined.
                            Style names: $(from_arr_to_str "$CUCKOO_DIST_VERSION_DESKTOP_STYLE_LIST").
    -z, --desktop-delete  Delete desktop file if exists.

        --version         Print the current version.
    -h, --help            Show this message.

  Arguments:

    -Q, --qemu-system     Run system emulator (by default: ${CUCKOO_EMULATOR_DEFAULT}).
    -B, --qemu-branch     Set ${CUCKOO_EMULATOR_NAME} branch for building.
    -A, --qemu-arch       Set ${CUCKOO_EMULATOR_NAME} architecture (by default: defined by OS).
                            ${CUCKOO_EMULATOR_NAME} architecture: $(from_arr_to_str "$CUCKOO_EMULATOR_ARCH_LIST").
    -O, --qemu-os-name    Set ${CUCKOO_EMULATOR_NAME} OS (by default: defined by OS).
                            ${CUCKOO_EMULATOR_NAME} OS: $(from_arr_to_str "$CUCKOO_EMULATOR_OS_LIST").
    -a, --arch            Set OS architecture (by default: defined by OS).
                            OS architecture: $(from_arr_to_str "$CUCKOO_ARCH_LIST").
    -o, --os-name         Set OS name (by default: ${CUCKOO_OS_DEFAULT}).
                            OS: $(from_arr_to_str "$CUCKOO_OS_LIST").
    -v, --dist-version    Set distro and(or) version (by default: ${CUCKOO_DIST_VERSION_DEFAULT}).
    -m, --memory-size     Set memory size (by default: ${CUCKOO_MEMORY_SIZE_DEFAULT}).
    -K, --cpu-cores       Set CPU cores (by default: ${CUCKOO_CPU_CORES_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_CORES_MAX}).
    -T, --cpu-threads     Set CPU threads (by default: ${CUCKOO_CPU_THREADS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_THREADS_MAX}).
    -S, --cpu-sockets     Set CPU sockets (by default: ${CUCKOO_CPU_SOCKETS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_SOCKETS_MAX}).
    -C, --cdrom-add       Set file with full path for non-bootable CDROM
                            to add drivers, packages, etc. (by default: ${CUCKOO_EMULATOR_HD_TYPE_DEFAULT}).
    -c, --cdrom-boot      Set file with full path for CDROM to boot from (IDE device).
    -f, --floppy-boot     Set file with full path for Floppy Disk.
    -M, --smb-dir         Set directory with full path for SMB share.
    -F, --full-screen     Set full screen mode.
    -N, --no-daemonize    Run without daemonizing.
    -t, --hd-type         Set hard drive type (by default: ${CUCKOO_EMULATOR_HD_TYPE_DEFAULT}).
                            HD type: $(from_arr_to_str "$CUCKOO_EMULATOR_HD_TYPE_LIST").
    -R, --opts-add        Append any other ${CUCKOO_EMULATOR_NAME} options.

_H_E_L_P
}


# Convert from Array to String
from_arr_to_str()
{
    local str=""
    local sep=","

    [ ! -z "$2" ] && sep="$2"

    for char in $1
    do
        if [ -z "$str" ]
        then
            str="$char"
        else
            str="${str}${sep} ${char}"
        fi
    done

    echo "$str"
}


# Valid value in array:
#   - return value if valid
#   - returm epty string if not valid
valid_value_in_arr()
{
    for value in $1
    do
        if [ "$value" = "$2" ]
        then
            echo "$value"
            break
        fi
    done

    echo ""
}
