
VIRT_EMULATOR_LIST="qemu"
VIRT_EMULATOR_DEFAULT="qemu"
VIRT_EMULATOR=""


CUCKOO_ACTION=""
CUCKOO_ACTION_DEFAULT="run"
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")" && pwd -P)}/"
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
CUCKOO_NO_DAEMONIZE=""
CUCKOO_HD_TYPE_LIST="ide, scsi, virtio"
CUCKOO_HD_TYPE=""
CUCKOO_HD_TYPE_DEFAULT="virtio"


QEMU_ACTION=""
QEMU_ACTION_DEFAULT="run"
QEMU_DIR="${QEMU_DIR:=${CUCKOO_DIR}../qemu}/"
QEMU_OS_LIST="linux macosx windows"
QEMU_OS=""
ACTION_QEMU_OS_LIST=""
QEMU_ARCH_LIST="x86 x86_64"
QEMU_ARCH=""
ACTION_QEMU_ARCH_LIST=""


# Help message definition
help_message()
{
    cat <<H_E_L_P

Usage: $(basename $0) [actions] [argumets]

  Actions:

    -s, --setup         Set directory with full path and setup Cuckoo.
    -b, --qemu-build    Build QEMU for OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -q, --qemu-remove   Remove QEMU file(s).
    -u, --iso-url       Download ISO file and setup in Cuckoo.
    -f, --iso-file      Local copy ISO file and setup in Cuckoo.
    -I, --iso-remove    Remove ISO file(s).
    -H, --hd-remove     Remove QEMU HD(s).
    -i, --install       Install OS on QEMU image(s).
    -r, --run           Run QEMU (by default).

    -v, --version       Print the current version.
    -h, --help          Show this message.

  Arguments:

    -A, --qemu-arch     Set QEMU architecture (by default: definition by OS).
                          QEMU architecture: $(from_arr_to_str "$QEMU_ARCH_LIST").
    -O, --qemu-os-name  Set QEMU OS (by default: definition by OS).
                          QEMU OS: $(from_arr_to_str "$QEMU_OS_LIST").
    -a, --arch          Set OS architecture (by default: definition by OS).
                          OS architecture: $(from_arr_to_str "$CUCKOO_ARCH_LIST").
    -o, --os-name       Set OS name (by default: ${CUCKOO_OS_DEFAULT}).
                          OS: $(from_arr_to_str "$CUCKOO_OS_LIST").
    -d, --dist-version  Set dist and(or) version (by default: ${CUCKOO_DIST_VERSION_DEFAULT}).
    -c, --boot-cdrom    Set file with full path for CDROM(IDE device).
    -p, --boot-floppy   Set file with full path for Floppy Disk.
    -D, --add-cdrom     Set file with full path for CDROM(iSCI device).
    -C, --cpu-cores     Set CPU cores (by default: ${CUCKOO_CPU_CORES_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_CORES_MAX}).
    -T, --cpu-threads   Set CPU threads (by default: ${CUCKOO_CPU_THREADS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_THREADS_MAX}).
    -S, --cpu-sockets   Set CPU sockets (by default: ${CUCKOO_CPU_SOCKETS_DEFAULT}, min: ${CUCKOO_CPU_MIN}, max: ${CUCKOO_CPU_SOCKETS_MAX}).
    -m, --memory-size   Set memory size (by default: ${CUCKOO_MEMORY_SIZE_DEFAULT}).
    -e, --smb-dir       Set directory with full path for SMB share.
    -F, --full-screen   Set full screen.
    -N, --no-daemonize  Running no daemonize.
    -t, --hd-type       Set hard drive type (by default: ${CUCKOO_HD_TYPE_DEFAULT}).
                          HD type: ${CUCKOO_HD_TYPE_LIST}.
    -P, --add-opts      Add other QEMU options.

H_E_L_P
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


# Setup
cuckoo_setup()
{
    CUCKOO_SETUP_DIR="${CUCKOO_SETUP_DIR}cuckoo/"

    mkdir -p "$CUCKOO_SETUP_DIR"

    echo "  Main file: copying..."
#    cp "${CUCKOO_DIR}cuckoo.sh" "$CUCKOO_SETUP_DIR"
#    cp "${CUCKOO_DIR}VERSION" "$CUCKOO_SETUP_DIR"

#    echo "  Lib files: copying..."
#    cp -r "${CUCKOO_DIR}lib/" "$CUCKOO_SETUP_DIR"

#    mkdir "${CUCKOO_SETUP_DIR}install/"
#    cp -r "${CUCKOO_DIR}install/etc/" "${CUCKOO_SETUP_DIR}install/"
#    cp -r "${CUCKOO_DIR}install/bin/" "${CUCKOO_SETUP_DIR}install/"

#    echo "  Main launch files: copying..."
#    mkdir "${CUCKOO_SETUP_DIR}qemu/"
#    cp $(ls "${CUCKOO_DIR}qemu/"*.bat) "${CUCKOO_SETUP_DIR}qemu/"
#    cp $(ls "${CUCKOO_DIR}qemu/"*.sh) "${CUCKOO_SETUP_DIR}qemu/"

#    mkdir "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"
#    cp -r "$QEMU_ARCH_BUILD_DIR" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"
#    cp -r "${QEMU_ARCH_DIR}install/" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"
#    cp -r "${QEMU_ARCH_DIR}run/" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/"

#    echo "  QEMU: copying..."
#    mkdir "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/bin/"
#    cp -r "${QEMU_ARCH_BIN_DIR}${CUCKOO_OS}" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/bin/"

#    echo "  HDs: copying..."
#    mkdir -p "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/"
#    cp -r "$QEMU_HD_CLEAN_DIR" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/"
#    mkdir -p "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
#    cp -r "$QEMU_HD_DIR" "${CUCKOO_SETUP_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}../"

    echo ""
    echo "Cuckoo has been setuped in '${CUCKOO_SETUP_DIR}'"
    echo ""
}


# QEMU build
qemu_build()
{
    QEMU_ENV_NO="yes"

    for qemu_arch in $ACTION_QEMU_ARCH_LIST
    do
        for qemu_os in $ACTION_QEMU_OS_LIST
        do
            QEMU_OS="$qemu_os"
            QEMU_ARCH="$qemu_arch"

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
    for qemu_arch in $ACTION_QEMU_ARCH_LIST
    do
        for qemu_os in $ACTION_QEMU_OS_LIST
        do
            QEMU_OS="$qemu_os"
            QEMU_ARCH="$qemu_arch"

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
        curl -o "$CUCKOO_ISO_FILE_SYS_PATH" "$CUCKOO_ISO_FILE_PATH"
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
        for cuckoo_arch in $ACTION_CUCKOO_ARCH_LIST
        do
            for cuckoo_os in $ACTION_CUCKOO_OS_LIST
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
        CUCKOO_OS="$ACTION_CUCKOO_OS_LIST"
        CUCKOO_ARCH="$ACTION_CUCKOO_ARCH_LIST"

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
        CUCKOO_OS="$ACTION_CUCKOO_OS_LIST"
        CUCKOO_ARCH="$ACTION_CUCKOO_ARCH_LIST"

        . "${CUCKOO_DIR}lib/var.sh"

        if [ -e "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ] && [ -d "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}" ]
        then
            rm -rf "${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"

            echo "HD(s) has been removed in directory '${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}'"
        else
            if [ -e "${CUCKOO_HD_ARCH_OS_DIR}" ] && [ -f "${CUCKOO_HD_ARCH_OS_DIR}" ]
            then
                rm -f "${CUCKOO_HD_ARCH_OS_DIR}"

                echo "HD(s) directory '${CUCKOO_HD_ARCH_OS_DIR}' has been removed"
            else
                echo "WARNING: HD(s) has been removed in directory '${CUCKOO_HD_ARCH_OS_DIR}'"
            fi
        fi
    fi
    echo ""
}


# Checking and default values
checking_and_default_values()
{
    # Emulator
    if [ -z "$VIRT_EMULATOR" ]
    then
        VIRT_EMULATOR="$VIRT_EMULATOR_DEFAULT"
    fi

    # QEMU
    if [ -z "$QEMU_ACTION" ]
    then
        QEMU_ACTION="$QEMU_ACTION_DEFAULT"
    fi

    if [ "$QEMU_ACTION" = "build" ] || [ "$QEMU_ACTION" = "remove" ]
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
    fi

    # Cuckoo
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

        if [ -z "$CUCKOO_CPU_THREADS" ]
        then
            CUCKOO_CPU_THREADS=$CUCKOO_CPU_THREADS_DEFAULT
        fi

        if [ -z "$CUCKOO_CPU_SOCKETS" ]
        then
            CUCKOO_CPU_SOCKETS=$CUCKOO_CPU_SOCKETS_DEFAULT
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
                ACTION_CUCKOO_ARCH_LIST="$CUCKOO_ARCH"
            fi
        else
            ACTION_CUCKOO_ARCH_LIST="$CUCKOO_ARCH"
        fi
    fi
}


# Options definition
ARGS_SHORT="s:bqu:f:IHirA:O:a:o:d:c:p:D:C:T:S:m:e:FNt:P:vh"
ARGS_LONG="setup:,qemu-build,qemu-remove,iso-url:,iso-file:,iso-remove,hd-remove,install,run,qemu-arch,qemu-os-name:,arch:,os-name:,dist-version:,boot-cdrom:,boot-floppy:,add-cdrom:,cpu-cores:,cpu-threads:,cpu-sockets:,memory-size:,smb-dir:,full-screen,no-daemonize,hd-type:,add-opts:,version,help"
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
    --add-cdrom | -D )
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
        CUCKOO_NO_DAEMONIZE="yes"
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
    --add-opts | -P )
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
    build )
        qemu_build
    ;;
    remove )
        qemu_remove
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
                if [ "$QEMU_ACTION" = "run" ]
                then
                    QEMU_ENV_NO="yes"
                    . "${CUCKOO_DIR}lib/var.sh"

                    if [ "$CUCKOO_ACTION" = "install" ]
                    then
                        . "${CUCKOO_DIR}lib/hd.sh"
                        CUCKOO_BOOT_CDROM_FILE="${CUCKOO_ISO_ARCH_OS_DIR}${CUCKOO_ISO_FILE}"
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
#        . "${CUCKOO_DIR}lib/var.sh"
#        cuckoo_setup
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
    * )
        error_message "Cuckoo action '${CUCKOO_ACTION}' does not supported"
    ;;
esac


exit 0
