
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")" && pwd -P)}/"
CUCKOO_OS_LIST="linux, netbsd, freebsd, openbsd, macosx, windows"
CUCKOO_ARCH_LIST="x86, x86_64"
CUCKOO_SETUP_DIR=""
CUCKOO_ACTION=""
CUCKOO_ACTION_DEFAULT="run"
CUCKOO_OS=""
CUCKOO_OS_DEFAULT="linux"
CUCKOO_ARCH=""
CUCKOO_DIST_VERSION=""
CUCKOO_DIST_VERSION_DEFAULT="debian/8.4"

QEMU_OS_LIST="linux, macosx, windows"
QEMU_ARCH_LIST="x86, x86_64"
QEMU_MEMORY_SIZE=""
QEMU_MEMORY_SIZE_DEFAULT="1G"
QEMU_HD_TYPE_LIST="ide, scsi, virtio"
QEMU_HD_TYPE=""
QEMU_HD_TYPE_DEFAULT="virtio"
QEMU_CPU_MIN=1
QEMU_CPU_CORES=
QEMU_CPU_CORES_DEFAULT=4
QEMU_CPU_CORES_MAX=16
QEMU_CPU_THREADS=
QEMU_CPU_THREADS_DEFAULT=2
QEMU_CPU_THREADS_MAX=16
QEMU_CPU_SOCKETS=
QEMU_CPU_SOCKETS_DEFAULT=$QEMU_CPU_MIN
QEMU_CPU_SOCKETS_MAX=4
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
    -r, --run           Run QEMU (by default).
    -a, --arch          Set OS architecture (by default: definition by OS).
                          OS architecture: ${CUCKOO_ARCH_LIST}.
    -o, --os-name       Set OS name (by default: ${CUCKOO_OS_DEFAULT}).
                          OS: ${CUCKOO_OS_LIST}.
    -d, --dist-version  Set dist and(or) version (by default: ${CUCKOO_DIST_VERSION_DEFAULT}).
    -m, --memory-size   Set memory size (by default: ${QEMU_MEMORY_SIZE_DEFAULT}).
    -c, --cdrom         Set file with full path for CDROM.
    -b, --smb-dir       Set directory with full path for SMB share.
    -t, --hd-type       Set hard drive type (by default: ${QEMU_HD_TYPE_DEFAULT}).
                          HD type: ${QEMU_HD_TYPE_LIST}.
    -A, --qemu-arch     Set QEMU architecture (by default: definition on OS).
                          QEMU architecture: ${QEMU_ARCH_LIST}.
                          QEMU OS: ${QEMU_OS_LIST}.
    -C, --cpu-cores     Set CPU cores (by default: ${QEMU_CPU_CORES_DEFAULT}, min: ${QEMU_CPU_MIN}, max: ${QEMU_CPU_CORES_MAX}).
    -T, --cpu-threads   Set CPU threads (by default: ${QEMU_CPU_THREADS_DEFAULT}, min: ${QEMU_CPU_MIN}, max: ${QEMU_CPU_THREADS_MAX}).
    -S, --cpu-sockets   Set CPU sockets (by default: ${QEMU_CPU_SOCKETS_DEFAULT}, min: ${QEMU_CPU_MIN}, max: ${QEMU_CPU_SOCKETS_MAX}).
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
    echo "Cuckoo has been installed in '${CUCKOO_SETUP_DIR}'"
    exit 0
}


# Options definition
ARGS_SHORT="s:ira:o:d:m:c:b:t:A:C:T:S:vh"
ARGS_LONG="setup:,install,run,arch:,os-name:,dist-version:,memory-size:,cdrom:,smb-dir:,hd-type:,qemu-arch:,cpu-cores:,cpu-threads:,cpu-sockets:,version,help"
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
    --qemu-arch | -A )
        case $2 in
            x86 | x86_64 )
                QEMU_ARCH="$2"
            ;;
            * )
                error_message "QEMU architecture '$2' does not supported"
            ;;
        esac
        shift 2
    ;;
    --cpu-cores | -C )
        if [ $2 -ge $QEMU_CPU_MIN ] && [ $2 -le $QEMU_CPU_CORES_MAX ]
        then
            QEMU_CPU_CORES=$2
        else
            error_message "Invalid value CPU cores '$2'"
        fi
        shift 2
    ;;
    --cpu-threads | -T )
        if [ $2 -ge $QEMU_CPU_MIN ] && [ $2 -le $QEMU_CPU_THREADS_MAX ]
        then
            QEMU_CPU_THREADS=$2
        else
            error_message "Invalid value CPU threads '$2'"
        fi
        shift 2
    ;;
    --cpu-sockets | -S )
        if [ $2 -ge $QEMU_CPU_MIN ] && [ $2 -le $QEMU_CPU_SOCKETS_MAX ]
        then
            QEMU_CPU_SOCKETS=$2
        else
            error_message "Invalid value CPU sockets '$2'"
        fi
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
then
    if [ -z "$CUCKOO_OS" ]
    then
        CUCKOO_OS="$CUCKOO_OS_DEFAULT"
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

if [ -z "$QEMU_CPU_CORES" ]
then
    QEMU_CPU_CORES=$QEMU_CPU_CORES_DEFAULT
fi

if [ -z "$QEMU_CPU_THREADS" ]
then
    QEMU_CPU_THREAD=$QEMU_CPU_THREADS_DEFAULT
fi

if [ -z "$QEMU_CPU_SOCKETS" ]
then
    QEMU_CPU_SOCKETS=$QEMU_CPU_SOCKETS_DEFAULT
fi


# Running
if [ -z "$CUCKOO_SETUP_DIR" ]
then
    . "${CUCKOO_DIR}lib/run.sh"
else
    cuckoo_setup
fi
