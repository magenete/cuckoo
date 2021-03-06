#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Options definition
cuckoo_args()
{
    ARGS_SHORT="s:irbIV:qd:p:e:lxD:P:E:LXWUZw:zQB:A:O:a:o:v:m:K:T:S:C:c:f:M:FNt:R:h"
    ARGS_LONG="setup:,install,run,qemu-build,qemu-list,qemu-version:,qemu-delete,iso-download:,iso-import:,iso-export:,iso-list,iso-delete,hd-download:,hd-import:,hd-export:,hd-list,hd-delete,config-create,config-update,config-delete,desktop-create:,desktop-delete,qemu-system,qemu-branch:,qemu-arch:,qemu-os-name:,arch:,os-name:,dist-version:,memory-size:,cpu-cores:,cpu-threads:,cpu-sockets:,cdrom-add:,cdrom-boot:,floppy-boot:,smb-dir:,full-screen,no-daemonize,hd-type:,opts-add:,version,help"
    OPTS="$(getopt -o "${ARGS_SHORT}" -l "${ARGS_LONG}" -a -- "$@" 2>/dev/null)"
    if [ $? -gt 0 ]
    then
        cuckoo_error "Invalid option(s) value"
    fi

    eval set -- "$OPTS"

    # Options parsing
    while [ $# -gt 0 ]
    do
        case $1 in
        -- )
            shift 1
        ;;

    # Actions

        --setup | -s )
            CUCKOO_ACTION="setup"
            if [ -d "$2" ]
            then
                CUCKOO_SETUP_DIR="${2}/"
                CUCKOO_EMULATOR_SETUP_DIR="${CUCKOO_SETUP_DIR}${CUCKOO}/"
                CUCKOO_EMULATOR_ACTION="setup"
            else
                cuckoo_error "Directory '${2}' does not exist, so it can not be used for setup"
            fi
            shift 2
        ;;
        --install | -i )
            CUCKOO_ACTION="install"
            shift 1
        ;;
        --run | -r )
            CUCKOO_ACTION="run"
            shift 1
        ;;
        --qemu-build | -b )
            CUCKOO_EMULATOR_ACTION="build"
            shift 1
        ;;
        --qemu-list | -I )
            CUCKOO_EMULATOR_ACTION="list"
            shift 1
        ;;
        --qemu-version | -V )
            CUCKOO_EMULATOR_ACTION="version"
            CUCKOO_EMULATOR_VERSION="$2"
            shift 2
        ;;
        --qemu-delete | -q )
            CUCKOO_EMULATOR_ACTION="delete"
            shift 1
        ;;
        --iso-download | -d )
            CUCKOO_ACTION="iso-setup"
            CUCKOO_ISO_FILE_PATH="$2"
            CUCKOO_ISO_FILE_NET="yes"
            shift 2
        ;;
        --iso-import | -p )
            CUCKOO_ACTION="iso-setup"

            if [ -f "$2" ]
            then
                CUCKOO_ISO_FILE_PATH="$2"
                CUCKOO_ISO_FILE_NET=""
            else
                cuckoo_error "ISO file '${2}' does not exist"
            fi
            shift 2
        ;;
        --iso-export | -e )
            CUCKOO_ACTION="iso-export"

            if [ -d "$2" ]
            then
                CUCKOO_ISO_FILE_PATH="${2}/"
                CUCKOO_ISO_FILE_NET=""
            else
                cuckoo_error "Directory '${2}' does not exist, so it can not be used for export"
            fi
            shift 2
        ;;
        --iso-list | -l )
            CUCKOO_ACTION="iso-list"
            shift 1
        ;;
        --iso-delete | -x )
            CUCKOO_ACTION="iso-delete"
            shift 1
        ;;
        --hd-download | -D )
            CUCKOO_ACTION="hd-setup"
            CUCKOO_HD_FILE_PATH="$2"
            CUCKOO_HD_FILE_NET="yes"
            shift 2
        ;;
        --hd-import | -P )
            CUCKOO_ACTION="hd-setup"

            if [ -f "$2" ] || [ -d "$2" ]
            then
                CUCKOO_HD_FILE_PATH="$2"
                CUCKOO_HD_FILE_NET=""
            else
                cuckoo_error "HD directory or file '${2}' does not exist"
            fi
            shift 2
        ;;
        --hd-export | -E )
            CUCKOO_ACTION="hd-export"

            if [ -d "$2" ]
            then
                CUCKOO_HD_FILE_PATH="${2}/"
                CUCKOO_HD_FILE_NET=""
            else
                cuckoo_error "Directory '${2}' does not exist, so it can not be used for export"
            fi
            shift 2
        ;;
        --hd-list | -L )
            CUCKOO_ACTION="hd-list"
            shift 1
        ;;
        --hd-delete | -X )
            CUCKOO_ACTION="hd-delete"
            shift 1
        ;;
        --config-create | -W )
            CUCKOO_ACTION="config"
            CUCKOO_DIST_VERSION_CONFIG="create"
            shift 1
        ;;
        --config-update | -U )
            CUCKOO_ACTION="config"
            CUCKOO_DIST_VERSION_CONFIG="update"
            shift 1
        ;;
        --config-delete | -Z )
            CUCKOO_ACTION="config"
            CUCKOO_DIST_VERSION_CONFIG="delete"
            shift 1
        ;;
        --desktop-create | -w )
            CUCKOO_ACTION="desktop"
            CUCKOO_DIST_VERSION_DESKTOP="create"
            CUCKOO_DIST_VERSION_DESKTOP_STYLE="$2"
            if [ -z "$(valid_value_in_arr "$CUCKOO_DIST_VERSION_DESKTOP_STYLE_LIST" "$2")" ]
            then
                cuckoo_error "Desktop style '${2}' is not supported"
            else
                CUCKOO_DIST_VERSION_DESKTOP_STYLE="$2"
            fi
            shift 2
        ;;
        --desktop-delete | -z )
            CUCKOO_ACTION="desktop"
            CUCKOO_DIST_VERSION_DESKTOP="delete"
            shift 1
        ;;

    # Arguments

        --qemu-system | -Q )
            CUCKOO_EMULATOR_ACTION="run-system"
            shift 1
        ;;
        --qemu-branch | -B )
            CUCKOO_EMULATOR_VERSION="$2"
            shift 2
        ;;
        --qemu-arch | -A )
            if [ -z "$(valid_value_in_arr "$CUCKOO_EMULATOR_ARCH_LIST" "$2")" ]
            then
                CUCKOO_EMULATOR_NAME="${CUCKOO_EMULATOR_NAME:=$CUCKOO_EMULATOR_NAME_DEFAULT}"
                cuckoo_error "${CUCKOO_EMULATOR_NAME} architecture '${2}' is not supported"
            else
                CUCKOO_EMULATOR_ARCH="$2"
            fi
            shift 2
        ;;
        --qemu-os-name | -O )
            if [ -z "$(valid_value_in_arr "$CUCKOO_EMULATOR_OS_LIST" "$2")" ]
            then
                CUCKOO_EMULATOR_NAME="${CUCKOO_EMULATOR_NAME:=$CUCKOO_EMULATOR_NAME_DEFAULT}"
                cuckoo_error "${CUCKOO_EMULATOR_NAME} OS '${2}' is not supported"
            else
                CUCKOO_EMULATOR_OS="$2"
            fi
            shift 2
        ;;
        --arch | -a )
            if [ -z "$(valid_value_in_arr "$CUCKOO_ARCH_LIST" "$2")" ]
            then
                cuckoo_error "OS architecture '${2}' is not supported"
            else
                CUCKOO_ARCH="$2"
            fi
            shift 2
        ;;
        --os-name | -o )
            if [ -z "$(valid_value_in_arr "$CUCKOO_OS_LIST" "$2")" ]
            then
                cuckoo_error "OS '${2}' is not supported"
            else
                CUCKOO_OS="$2"
            fi
            shift 2
        ;;
        --dist-version | -v )
            if [ -z "$(cuckoo_dist_version_value_check "$2")" ]
            then
                cuckoo_error "Invalid distributive/version '${2}'"
            else
                CUCKOO_DIST_VERSION="$2"
            fi
            shift 2
        ;;
        --memory-size | -m )
            CUCKOO_MEMORY_SIZE="$2"
            shift 2
        ;;
        --cpu-cores | -K )
            if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_CORES_MAX ]
            then
                CUCKOO_CPU_CORES=$2
            else
                cuckoo_error "Invalid number of CPU cores '${2}'"
            fi
            shift 2
        ;;
        --cpu-threads | -T )
            if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_THREADS_MAX ]
            then
                CUCKOO_CPU_THREADS=$2
            else
                cuckoo_error "Invalid number of CPU threads '${2}'"
            fi
            shift 2
        ;;
        --cpu-sockets | -S )
            if [ $2 -ge $CUCKOO_CPU_MIN ] && [ $2 -le $CUCKOO_CPU_SOCKETS_MAX ]
            then
                CUCKOO_CPU_SOCKETS=$2
            else
                cuckoo_error "Invalid number of CPU sockets '${2}'"
            fi
            shift 2
        ;;
        --cdrom-add | -C )
            if [ -f "$2" ]
            then
                CUCKOO_CDROM_ADD_FILE="$2"
            else
                cuckoo_error "CDROM file '${2}' does not exist, so it can not be added"
            fi
            shift 2
        ;;
        --cdrom-boot | -c )
            if [ -f "$2" ]
            then
                CUCKOO_CDROM_BOOT_FILE="$2"
            else
                cuckoo_error "CDROM file '${2}' does not exist"
            fi
            shift 2
        ;;
        --floppy-boot | -f )
            if [ -f "$2" ]
            then
                CUCKOO_FLOPPY_BOOT_FILE="$2"
            else
                cuckoo_error "Floppy Disk file '${2}' does not exist"
            fi
            shift 2
        ;;
        --smb-dir | -M )
            if [ -d "$2" ]
            then
                CUCKOO_SMB_DIR="$2"
            else
                cuckoo_error "SMB directory '${2}' does not exist"
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
            if [ -z "$(valid_value_in_arr "$CUCKOO_EMULATOR_HD_TYPE_LIST" "$2")" ]
            then
                cuckoo_error "HD type '${2}' is not supported"
            else
                CUCKOO_HD_TYPE="$2"
            fi
            shift 2
        ;;
        --opts-add | -R )
            CUCKOO_OPTS_EXT="$2"
            shift 2
        ;;
        --version | -V )
            CUCKOO_ENV_NO="yes"

            cuckoo_variables

            echo "Cuckoo version: $(cat "${CUCKOO_ETC_VERSION_FILE}")"
            exit 0
        ;;
        --help | -h )
            cuckoo_help
            exit 0
        ;;
        * )
            cuckoo_error "Invalid option(s)"
        ;;
        esac
    done
}
