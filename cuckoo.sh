
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")" && pwd -P)}/"
CUCKOO_SETUP_DIR=""
CUCKOO_ACTION=""
CUCKOO_ACTION_DEFAULT="run"
CUCKOO_OS=""
CUCKOO_OS_DEFAULT="linux"
CUCKOO_ARCH=""
CUCKOO_ARCH_DEFAULT="x86_64"
CUCKOO_ISO_FILE=""
CUCKOO_ISO_FILE_DEFAULT="debian/8.4"
CUCKOO_DIST_VERSION=""
CUCKOO_DIST_VERSION_DEFAULT="$CUCKOO_ISO_FILE_DEFAULT"

QEMU_MEMORY_SIZE=""
QEMU_MEMORY_SIZE_DEFAULT="1G"
QEMU_HD_TYPE=""
QEMU_HD_TYPE_DEFAULT="virtio"
QEMU_CDROM_FILE=""
QEMU_SMB_DIR=""


# Help message definition
help_message()
{
    cat <<H_E_L_P

Usage: $(basename $0) [options]
Options:
    -s, --setup         Set directory with full path and setup Cuckoo.
    -i, --install       Install on QEMU image(s).
    -r, --run           Run QEMU(by default).
    -a, --arch          Set OS architecture (by default: x86_64).
    -o, --os-name       Set OS name (by default: linux).
                          OS: linux, netbsd, freebsd, openbsd, macosx, windows.
    -f, --iso-file      Set ISO file name only.
    -d, --dist-version  Set dist and(or) version(by default: debian/8.4).
    -m, --memory-size   Set memory size (by default: 1G).
    -c, --cdrom         Set file with full path for CDROM.
    -b, --smb-dir       Set directory with full path for SMB share.
    -t, --hd-type       Set hard drive type (by default: virtio).
                          HD type: ide, scsi, virtio.
    -v, --version       Print the current version.
    -h, --help          Show this message.

H_E_L_P
}


# Print error message and exit
error_message()
{
    help_message
    echo "ERROR: $1"
    echo ""
    exit 1
}


# Setup
cuckoo_setup()
{

}


# Options definition
ARGS_SHORT="s:ira:o:f:d:m:c:b:t:vh"
ARGS_LONG="setup:,install,run,arch:,os-name:,iso-file:,dist-version:,memory-size:,cdrom:,smb-dir:,hd-type:,version,help"
OPTS="$(getopt -o "${ARGS_SHORT}" -l "${ARGS_LONG}" -a -- "$@" 2>/dev/null)"
if [ "$?" != "0" ]
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
            CUCKOO_SETUP_DIR="${2}/cuckoo/"
        else
            error_message "Directory '$2' does not exist for setup"
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
    --os-name | -o )
        case $2 in
            linux | netbsd | freebsd | openbsd | macosx | windows )
                CUCKOO_OS="$2"
            ;;
            * )
                error_message "OS '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --arch | -a )
        case $2 in
            x86 | x86_64 )
                CUCKOO_ARCH="$2"
            ;;
            * )
                error_message "OS architecture '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --iso-file | -f )
        CUCKOO_ISO_FILE="$2"
        shift 2
    ;;
    --dist-version | -d )
        CUCKOO_DIST_VERSION="$2"
        shift 2
    ;;
    --memory-size | -m )
        QEMU_MEMORY_SIZE="$2"
        shift 2
    ;;
    --cdrom | -c )
        if [ -e "$2" ] && [ -f "$2" ]
        then
            QEMU_CDROM_FILE="$2"
        else
            error_message "File '$2' does not exist for CDROM"
        fi
        shift 2
    ;;
    --smb-dir | -b )
        if [ -e "$2" ] && [ -d "$2" ]
        then
            QEMU_SMB_DIR="$2"
        else
            error_message "Directory '$2' does not exist for SMB"
        fi
        shift 2
    ;;
    --hd-type | -t )
        case $2 in
            ide | scsi | virtio )
                QEMU_HD_TYPE="$2"
            ;;
            * )
                error_message "HD type '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --version | -v )
        echo "Version: 0.1.0"
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


# Checking of default values
if [ -z "$CUCKOO_ACTION" ]
then
    CUCKOO_ACTION="$CUCKOO_ACTION_DEFAULT"
fi

if [ -z "$CUCKOO_SETUP_DIR" ]
    if [ -z "$CUCKOO_OS" ]
    then
        CUCKOO_OS="$CUCKOO_OS_DEFAULT"
    fi

    if [ -z "$CUCKOO_ARCH" ]
    then
        CUCKOO_ARCH="$CUCKOO_ARCH_DEFAULT"
    fi

    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION_DEFAULT"
    fi
fi

if [ -z "$QEMU_MEMORY_SIZE" ]
then
    QEMU_MEMORY_SIZE="$QEMU_MEMORY_SIZE_DEFAULT"
fi

if [ -z "$QEMU_HD_TYPE" ]
then
    QEMU_HD_TYPE="$QEMU_HD_TYPE_DEFAULT"
fi


# Running
if [ -z "$CUCKOO_SETUP_DIR" ]
    . "${CUCKOO_DIR}lib/env.sh"
    . "${CUCKOO_DIR}lib/run.sh"
else
    cuckoo_setup
fi
