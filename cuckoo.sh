
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")" && pwd -P)}/"
CUCKOO_SETUP_DIR=""
CUCKOO_ACTION=""
CUCKOO_ACTION_DEFAULT="run"
CUCKOO_OS_LIST="linux netbsd freebsd openbsd macosx windows"
CUCKOO_OS=""
CUCKOO_OS_DEFAULT="linux"
CUCKOO_ARCH_LIST="x86 x86_64"
CUCKOO_ARCH=""
CUCKOO_DIST_VERSION=""
CUCKOO_DIST_VERSION_DEFAULT="debian/8.4"
CUCKOO_ISO_FILE=""
CUCKOO_ISO_FILE_NET=""
CUCKOO_ISO_FILE_PATH=""

QEMU_OS_LIST="linux macosx windows"
QEMU_OS=""
QEMU_ARCH_LIST="x86 x86_64"
QEMU_ARCH=""
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

Usage: $(basename $0) [actions] [argumets]

  Actions:

    -s, --setup         Set directory with full path and setup Cuckoo.
    -i, --install       Install OS on QEMU image(s).
    -r, --run           Run QEMU (by default).
    -b, --build         Set and build QEMU OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -H, --hd-remove     Remove QEMU HD(s).
    -I, --iso-remove    Remove ISO file(s).
    -Q, --qemu-remove   Remove QEMU file(s).
    -u, --iso-url       Download ISO file and setting in Cuckoo.
    -f, --iso-file      Copy ISO file in Cuckoo.

    -v, --version       Print the current version.
    -h, --help          Show this message.

  Arguments:

    -a, --arch          Set OS architecture (by default: definition by OS).
                          OS architecture: $(from_arr_to_str "$CUCKOO_ARCH_LIST").
    -o, --os-name       Set OS name (by default: ${CUCKOO_OS_DEFAULT}).
                          OS: $(from_arr_to_str "$CUCKOO_OS_LIST").
    -d, --dist-version  Set dist and(or) version (by default: ${CUCKOO_DIST_VERSION_DEFAULT}).
    -m, --memory-size   Set memory size (by default: ${QEMU_MEMORY_SIZE_DEFAULT}).
    -c, --cdrom         Set file with full path for CDROM.
    -e, --smb-dir       Set directory with full path for SMB share.
    -t, --hd-type       Set hard drive type (by default: ${QEMU_HD_TYPE_DEFAULT}).
                          HD type: ${QEMU_HD_TYPE_LIST}.
    -A, --qemu-arch     Set QEMU architecture (by default: definition on OS).
                          QEMU architecture: $(from_arr_to_str "$QEMU_ARCH_LIST").
    -O, --qemu-os-name  Set QEMU OS (worls only for building).
                          QEMU OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -C, --cpu-cores     Set CPU cores (by default: ${QEMU_CPU_CORES_DEFAULT}, min: ${QEMU_CPU_MIN}, max: ${QEMU_CPU_CORES_MAX}).
    -T, --cpu-threads   Set CPU threads (by default: ${QEMU_CPU_THREADS_DEFAULT}, min: ${QEMU_CPU_MIN}, max: ${QEMU_CPU_THREADS_MAX}).
    -S, --cpu-sockets   Set CPU sockets (by default: ${QEMU_CPU_SOCKETS_DEFAULT}, min: ${QEMU_CPU_MIN}, max: ${QEMU_CPU_SOCKETS_MAX}).
    -P, --qemu-opts     Set other QEMU options.

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


# Setup
cuckoo_setup()
{
    CUCKOO_SETUP_DIR="${CUCKOO_SETUP_DIR}cuckoo/"

    mkdir -p "$CUCKOO_SETUP_DIR"

    echo "  Main file: copying..."
    cp "${CUCKOO_DIR}cuckoo.sh" "$CUCKOO_SETUP_DIR"
    cp "${CUCKOO_DIR}VERSION" "$CUCKOO_SETUP_DIR"

    echo "  Lib files: copying..."
    cp -r "${CUCKOO_DIR}lib/" "$CUCKOO_SETUP_DIR"

    mkdir "${CUCKOO_SETUP_DIR}install/"
    cp -r "${CUCKOO_DIR}install/etc/" "${CUCKOO_SETUP_DIR}install/"
    cp -r "${CUCKOO_DIR}install/bin/" "${CUCKOO_SETUP_DIR}install/"

    echo "  Main launch files: copying..."
    mkdir "${CUCKOO_SETUP_DIR}qemu/"
    cp $(ls "${CUCKOO_DIR}qemu/"*.bat) "${CUCKOO_SETUP_DIR}qemu/"
    cp $(ls "${CUCKOO_DIR}qemu/"*.sh) "${CUCKOO_SETUP_DIR}qemu/"

    mkdir "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"
    cp -r "$QEMU_ARCH_BUILD_DIR" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"
    cp -r "${QEMU_ARCH_DIR}install/" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"
    cp -r "${QEMU_ARCH_DIR}run/" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"

    echo "  QEMU: copying..."
    mkdir "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/bin/"
    cp -r "${QEMU_ARCH_BIN_DIR}${CUCKOO_OS}" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/bin/"

    echo "  HDs: copying..."
    mkdir -p "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/"
    cp -r "$QEMU_HD_CLEAN_DIR" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/"
    mkdir -p "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
    cp -r "$QEMU_HD_DIR" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}../"

    echo ""
    echo "Cuckoo has been setuped in '${CUCKOO_SETUP_DIR}'"
    echo ""
}


# QEMU build
cuckoo_qemu_build()
{
    CUCKOO_ENV_NO="yes"

    for qemu_arch in $ACTION_QEMU_ARCH_LIST
    do
        for qemu_os in $ACTION_QEMU_OS_LIST
        do
            . "${CUCKOO_DIR}lib/var.sh"

            qemu_build_file="${QEMU_DIR}${qemu_arch}/build/${qemu_os}.sh"

            if [ -e "$qemu_build_file" ] && [ -f "$qemu_build_file" ]
            then
                QEMU_OS="$qemu_os"
                QEMU_ARCH="$qemu_arch"

                . "$qemu_build_file"

                echo ""
                echo "QEMU has been builded in '${QEMU_ARCH_BIN_OS_DIR}${QEMU_VERSION}'"
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
cuckoo_qemu_remove()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    for qemu_arch in $ACTION_QEMU_ARCH_LIST
    do
        for qemu_os in $ACTION_QEMU_OS_LIST
        do
            . "${CUCKOO_DIR}lib/var.sh"

            qemu_remove_dir="${QEMU_DIR}${qemu_arch}/bin/${qemu_os}/"

            if [ -e "$qemu_remove_dir" ] && [ -d "$qemu_remove_dir" ]
            then
                QEMU_OS="$qemu_os"
                QEMU_ARCH="$qemu_arch"

                rm -rf "$qemu_remove_dir"

                echo "QEMU has been removed in '${QEMU_ARCH_BIN_OS_DIR}'"
            else
                echo "WARNING: QEMU has not been removed for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done
    echo ""
}


# QEMU HDs remove
cuckoo_hd_remove()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $ACTION_CUCKOO_ARCH_LIST
        do
            for cuckoo_os in $ACTION_CUCKOO_OS_LIST
            do
                CUCKOO_OS="$cuckoo_os"
                CUCKOO_ARCH="$cuckoo_arch"

                . "${CUCKOO_DIR}lib/var.sh"

                if [ -e "$CUCKOO_ISO_DIR" ] && [ -d "$CUCKOO_ISO_DIR" ]
                then
#                    rm -rf "$CUCKOO_ISO_DIR"
#                    mkdir "$CUCKOO_ISO_DIR"

                    echo "ISO file(s) has been removed in '${CUCKOO_ISO_DIR}'"
                else
                    echo "WARNING: ISO file(s) has not been removed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_OS="$ACTION_CUCKOO_OS_LIST"
        CUCKOO_ARCH="$ACTION_CUCKOO_ARCH_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}" ] && [ -f "${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}" ]
        then
#            rm -f "${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}"

            echo "ISO file '${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}' has been removed"
        else
            echo "WARNING: ISO file '${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}' has not been removed"
        fi
    fi
    echo ""
}


# ISO files remove
cuckoo_iso_remove()
{
    CUCKOO_ENV_NO="yes"

    echo ""
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        for cuckoo_arch in $ACTION_CUCKOO_ARCH_LIST
        do
            for cuckoo_os in $ACTION_CUCKOO_OS_LIST
            do
                CUCKOO_OS="$cuckoo_os"
                CUCKOO_ARCH="$cuckoo_arch"

                . "${CUCKOO_DIR}lib/var.sh"

                if [ -e "$CUCKOO_ISO_DIR" ] && [ -d "$CUCKOO_ISO_DIR" ]
                then
                    rm -rf "$CUCKOO_ISO_DIR"
                    mkdir "$CUCKOO_ISO_DIR"

                    echo "ISO file(s) has been removed in '${CUCKOO_ISO_DIR}'"
                else
                    echo "WARNING: ISO file(s) has not been removed for OS: ${CUCKOO_OS}, arch: ${CUCKOO_ARCH}"
                fi
            done
        done
    else
        CUCKOO_OS="$ACTION_CUCKOO_OS_LIST"
        CUCKOO_ARCH="$ACTION_CUCKOO_ARCH_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}" ] && [ -f "${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}" ]
        then
            rm -f "${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}"

            echo "ISO file '${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}' has been removed"
        else
            echo "WARNING: ISO file '${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}' has not been removed"
        fi
    fi
    echo ""
}


# ISO file setup
cuckoo_iso_setup()
{
    CUCKOO_ISO_FILE_SYS_PATH="${CUCKOO_ISO_DIR}${CUCKOO_DIST_VERSION}.iso"
    CUCKOO_ISO_FILE_DIR="$(dirname "$CUCKOO_ISO_FILE_SYS_PATH")/"
    CUCKOO_ISO_FILE="$(basename "$CUCKOO_ISO_FILE_SYS_PATH")"

    mkdir -p "${CUCKOO_ISO_FILE_DIR}"

    if [ -z "$CUCKOO_ISO_FILE_NET" ]
    then
        cp -f "$CUCKOO_ISO_FILE_PATH" "$CUCKOO_ISO_FILE_SYS_PATH"
    else
        curl -o "$CUCKOO_ISO_FILE_SYS_PATH" "$CUCKOO_ISO_FILE_PATH"
    fi

    echo ""
    echo "ISO file has been setuped as '${CUCKOO_ISO_FILE_SYS_PATH}'"
    echo ""
}


# Options definition
ARGS_SHORT="s:irbHIQu:f:a:o:d:m:c:e:t:A:O:C:T:S:P:vh"
ARGS_LONG="setup:,install,run,build,hd-remove,iso-remove,qemu-remove,iso-url:,iso-file:,arch:,os-name:,dist-version:,memory-size:,cdrom:,smb-dir:,hd-type:,qemu-arch:,qemu-os-name:,cpu-cores:,cpu-threads:,cpu-sockets:,qemu-opts:,version,help"
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
    --build | -b )
        CUCKOO_ACTION="build"
        shift 1
    ;;
    --hd-remove | -H )
        CUCKOO_ACTION="hd-remove"
        shift 1
    ;;
    --qemu-remove | -Q )
        CUCKOO_ACTION="qemu-remove"
        shift 1
    ;;
    --iso-remove | -I )
        CUCKOO_ACTION="iso-remove"
        shift 1
    ;;
    --iso-url | -u )
        CUCKOO_ACTION="iso"
        CUCKOO_ISO_FILE_PATH="$2"
        CUCKOO_ISO_FILE_NET="yes"
        shift 2
    ;;
    --iso-file | -f )
        CUCKOO_ACTION="iso"
        if [ -e "$2" ] && [ -f "$2" ]
        then
            CUCKOO_ISO_FILE_PATH="$2"
            CUCKOO_ISO_FILE_NET=""
        else
            error_message "File ISO '$2' does not exist"
        fi
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
    --smb-dir | -e )
        if [ -e "$2" ] && [ -d "$2" ]
        then
            QEMU_SMB_DIR="$2"
        else
            error_message "Directory '$2' does not exist for SMB"
        fi
        shift 2
    ;;
    --hd-type | -t )
        case "$2" in
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
    --qemu-opts | -Q )
        QEMU_OPTS_EXT="$2"
        shift 2
    ;;
    --version | -v )
        echo "Cuckoo version: $(cat "${CUCKOO_DIR}VERSION")"
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

if [ "$CUCKOO_ACTION" = "run" ] || [ "$CUCKOO_ACTION" = "install" ]
then
    if [ -z "$CUCKOO_OS" ]
    then
        CUCKOO_OS="$CUCKOO_OS_DEFAULT"
    fi

    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        CUCKOO_DIST_VERSION="$CUCKOO_DIST_VERSION_DEFAULT"
    fi

    if [ -z "$CUCKOO_ARCH" ]
    then
        . "${CUCKOO_DIR}lib/env.sh"
        CUCKOO_ARCH="$QEMU_ARCH"
    fi
else
    if [ "$CUCKOO_ACTION" = "build" ] || [ "$CUCKOO_ACTION" = "qemu-remove" ]
    then
        if [ -z "$QEMU_OS" ]
        then
            ACTION_QEMU_OS_LIST="$QEMU_OS_LIST"
        else
            ACTION_QEMU_OS_LIST="$QEMU_OS"
        fi

        if [ -z "$QEMU_ARCH" ]
        then
            ACTION_QEMU_ARCH_LIST="$QEMU_ARCH_LIST"
        else
            ACTION_QEMU_ARCH_LIST="$QEMU_ARCH"
        fi
    else
        if [ -z "$CUCKOO_OS" ]
        then
            if [ -z "$CUCKOO_DIST_VERSION" ]
            then
                ACTION_CUCKOO_OS_LIST="$CUCKOO_OS_LIST"
            else
                ACTION_CUCKOO_OS_LIST="$CUCKOO_OS_DEFAULT"
            fi
        else
            ACTION_CUCKOO_OS_LIST="$CUCKOO_OS"
        fi

        if [ -z "$CUCKOO_ARCH" ]
        then
            if [ -z "$CUCKOO_DIST_VERSION" ]
            then
                ACTION_CUCKOO_ARCH_LIST="$CUCKOO_ARCH_LIST"
            else
                . "${CUCKOO_DIR}lib/env.sh"
                ACTION_CUCKOO_ARCH_LIST="$QEMU_ARCH"
            fi
        else
            ACTION_CUCKOO_ARCH_LIST="$CUCKOO_ARCH"
        fi
    fi
fi


# Running
case "$CUCKOO_ACTION" in
    run | install )
        . "${CUCKOO_DIR}lib/run.sh"
    ;;
    build )
        cuckoo_qemu_build
    ;;
    setup )
        . "${CUCKOO_DIR}lib/var.sh"
        cuckoo_setup
    ;;
    iso )
        . "${CUCKOO_DIR}lib/var.sh"
        cuckoo_iso_setup
    ;;
    iso-remove )
        cuckoo_iso_remove
    ;;
    hd-remove )
        cuckoo_hd_remove
    ;;
    qemu-remove )
        cuckoo_qemu_remove
    ;;
    * )
        error_message "Cuckoo action '${CUCKOO_ACTION}' does not supported"
    ;;
esac


exit 0
