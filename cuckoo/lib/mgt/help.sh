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
    cat << _H_E_L_P

Usage: $(basename $0) [actions] [argumets]

  Actions:

    -s, --setup           Set directory with full path and setup Cuckoo.
    -i, --install         Install OS on HD(s) (QEMU image).
    -r, --run             Run VM (by default: QEMU).
    -b, --qemu-build      Build (only on Linux) QEMU for OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -q, --qemu-delete     Delete QEMU file(s).
    -d, --iso-download    Download ISO file and setup.
    -c, --iso-copy        Local copy ISO file and setup.
    -l, --iso-list        Get list of existing ISO files.
    -x, --iso-delete      Delete ISO file(s).
    -D, --hd-download     Download HD tar (bz2) file and setup.
    -C, --hd-copy         Local copy HD tar file and setup.
    -L, --hd-list         Get list of existing HD(s) files.
    -X, --hd-delete       Delete HD(s).
    -W, --config-create   Create and write config file if --dist-version defined.
    -U, --config-update   Update config file if exists.
    -Z, --config-delete   Delete config file if exists.
    -w, --desktop-create  Create and write desktop file if --dist-version defined.
    -z, --desktop-delete  Delete desktop file if exists.

    -V, --version         Print the current version.
    -h, --help            Show this message.

  Arguments:

    -Q, --qemu-system     Run system VM (by default: QEMU).
    -A, --qemu-arch       Set QEMU architecture (by default: definition by OS).
                            QEMU architecture: $(from_arr_to_str "$QEMU_ARCH_LIST").
    -O, --qemu-os-name    Set QEMU OS (by default: definition by OS).
                            QEMU OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -a, --arch            Set OS architecture (by default: definition by OS).
                            OS architecture: $(from_arr_to_str "$CUCKOO_ARCH_LIST").
    -o, --os-name         Set OS name (by default: ${CUCKOO_OS_DEFAULT}).
                            OS: $(from_arr_to_str "$CUCKOO_OS_LIST").
    -v, --dist-version    Set dist and(or) version (by default: ${CUCKOO_DIST_VERSION_DEFAULT}).
    -m, --memory-size     Set memory size (by default: ${CUCKOO_MEMORY_SIZE_DEFAULT}).
    -K, --cpu-cores       Set CPU cores (by default: ${CUCKOO_CPU_CORES_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_CORES_MAX}).
    -T, --cpu-threads     Set CPU threads (by default: ${CUCKOO_CPU_THREADS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_THREADS_MAX}).
    -S, --cpu-sockets     Set CPU sockets (by default: ${CUCKOO_CPU_SOCKETS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_SOCKETS_MAX}).
    -M, --cdrom-add       Set file with full path for CDROM (by default: ${CUCKOO_HD_TYPE_DEFAULT}).
    -p, --boot-cdrom      Set file with full path for CDROM (IDE device).
    -f, --boot-floppy     Set file with full path for Floppy Disk.
    -e, --smb-dir         Set directory with full path for SMB share.
    -F, --full-screen     Set full screen.
    -N, --no-daemonize    Running no daemonize.
    -t, --hd-type         Set hard drive type (by default: ${CUCKOO_HD_TYPE_DEFAULT}).
                            HD type: ${CUCKOO_HD_TYPE_LIST}.
    -P, --opts-add        Add other QEMU options.

_H_E_L_P
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
