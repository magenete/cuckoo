
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_ARCH="${CUCKOO_ARCH:=x86_64}"
CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE:=}"
if [ ! -z "$CUCKOO_ISO_FILE" ]
then
    if [ -z "$CUCKOO_DIST_VERSION" ]
    then
        CUCKOO_DIST_VERSION="$CUCKOO_ISO_FILE"
        CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
    fi
    CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE}.iso"
fi
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=}"
if [ -z "$CUCKOO_DIST_VERSION" ]
then
    CUCKOO_DIST_VERSION_DIR=""
else
    CUCKOO_DIST_VERSION_DIR="${CUCKOO_DIST_VERSION}/"
fi
CUCKOO_CPU_CORES=${CUCKOO_CPU_CORES:=4}
CUCKOO_CPU_THREADS=${CUCKOO_CPU_THREADS:=2}
CUCKOO_CPU_SOCKETS=${CUCKOO_CPU_SOCKETS:=1}
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"
CUCKOO_CURRENT_DIR="$(cd "$(dirname "$0")/.." && pwd -P)/"
case $CUCKOO_ARCH in
    x86_64 )
        CUCKOO_OS_BIT=64
    ;;
    x86 )
        CUCKOO_OS_BIT=32
    ;;
esac
CUCKOO_ISO_DIR="${CUCKOO_CURRENT_DIR}../../install/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/"

QEMU_NAME="qemu"
QEMU_OS="${QEMU_OS:=linux}"
QEMU_ARCH="${QEMU_ARCH:=x86_64}"
QEMU_HD="${QEMU_HD:=virtio}"
QEMU_CDROM_FILE="${QEMU_CDROM_FILE:=}"
QEMU_SMB_DIR="${QEMU_SMB_DIR:=}"
QEMU_NO_USB="${QEMU_NO_USB:=}"
QEMU_FULL_SCREEN="${QEMU_FULL_SCREEN:=}"
QEMU_NO_DAEMONIZE="${QEMU_NO_DAEMONIZE:=}"
QEMU_MEMORY_SIZE="${QEMU_MEMORY_SIZE:=1G}"
QEMU_VERSION="$(cat ${CUCKOO_CURRENT_DIR}bin/${QEMU_OS}/VERSION 2> /dev/null)"
QEMU_BIN_DIR="${CUCKOO_CURRENT_DIR}bin/${QEMU_OS}/${QEMU_VERSION}/"
QEMU_TMP_DIR="${CUCKOO_TMP_DIR}${QEMU_NAME}/"
QEMU_HD_DIR="${CUCKOO_CURRENT_DIR}hd/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
QEMU_BIN_FILE="bin/${QEMU_NAME}-system-${QEMU_ARCH}"
QEMU_OPTS="${QEMU_OPTS:=}"


##  ENV check

if [ -z "$QEMU_VERSION" ]
then
    echo "ERROR: QEMU version was not defined"
    echo "Please check file '${CUCKOO_CURRENT_DIR}bin/${QEMU_OS}/VERSION'"
    exit 1
fi

if [ ! -d "$QEMU_BIN_DIR" ]
then
    echo "ERROR: Directory '${QEMU_BIN_DIR}' does not exist"
    exit 1
fi

if [ ! -f "${QEMU_BIN_DIR}${QEMU_BIN_FILE}" ]
then
    echo "ERROR: File '${QEMU_BIN_DIR}${QEMU_BIN_FILE}' does not exist"
    exit 1
fi


##  Copy in TMP_DIR

"${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -version > /dev/null
if [ ! $? -eq 0 ]
then
    mkdir -p "$QEMU_TMP_DIR"

    if [ -d "$QEMU_TMP_DIR" ]
    then
        cp -rf "$QEMU_BIN_DIR" "$QEMU_TMP_DIR"

        if [ -d "${QEMU_TMP_DIR}${QEMU_VERSION}/" ]
        then
            QEMU_BIN_DIR="${QEMU_TMP_DIR}${QEMU_VERSION}/"
            chmod -R 750 "$QEMU_BIN_DIR"

            if [ ! -x "${QEMU_BIN_DIR}${QEMU_BIN_FILE}" ]
            then
                echo "ERROR: File '${QEMU_BIN_DIR}${QEMU_BIN_FILE}' does not exist"
                exit 1
            fi
        else
            echo "ERROR: Directory '${QEMU_TMP_DIR}${QEMU_VERSION}/' does not exist"
            exit 1
        fi
    else
        echo "ERROR: Directory '${QEMU_TMP_DIR}' does not exist"
        exit 1
    fi
fi


##  QEMU run

# Bootloading and CDROM
QEMU_OPTS="${QEMU_OPTS} -boot order="
if [ -z "$QEMU_CDROM_FILE" ] && [ -z "$CUCKOO_ISO_FILE" ]
then
    QEMU_OPTS="${QEMU_OPTS}c"
else
    if [ ! -z "$CUCKOO_ISO_FILE" ]
    then
        QEMU_OPTS="${QEMU_OPTS}d -cdrom ${CUCKOO_ISO_DIR}${CUCKOO_ISO_FILE}"
    fi
    if [ ! -z "$QEMU_CDROM_FILE" ]
    then
        QEMU_OPTS="${QEMU_OPTS}d -cdrom ${QEMU_CDROM_FILE}"
    fi
fi

# Memory
QEMU_OPTS="${QEMU_OPTS} -m ${QEMU_MEMORY_SIZE} -balloon virtio"

# CPU
QEMU_OPTS="${QEMU_OPTS} -cpu ${QEMU_NAME}${CUCKOO_OS_BIT} -smp cpus=$((${CUCKOO_CPU_CORES}*${CUCKOO_CPU_THREADS}*${CUCKOO_CPU_SOCKETS})),cores=${CUCKOO_CPU_CORES},threads=${CUCKOO_CPU_THREADS},sockets=${CUCKOO_CPU_SOCKETS}"

# Drive
for qemu_disk in $(ls $QEMU_HD_DIR)
do
    if [ -f "${QEMU_HD_DIR}${qemu_disk}" ]
    then
        QEMU_OPTS="${QEMU_OPTS} -drive media=disk,if=${QEMU_HD},index=${qemu_disk},file=${QEMU_HD_DIR}${qemu_disk}"
    fi
done

# Screen
QEMU_OPTS="${QEMU_OPTS} -vga std -sdl -display sdl"

# USB
if [ -z "$QEMU_NO_USB" ]
then
    QEMU_OPTS="${QEMU_OPTS} -usb -usbdevice tablet -device piix3-usb-uhci"
fi

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
QEMU_OPTS="${QEMU_OPTS} -enable-kvm"

# Daemonize
if [ -z "$QEMU_NO_DAEMONIZE" ]
then
    QEMU_OPTS="${QEMU_OPTS} -daemonize"
fi

"${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -name " Cuckoo [${CUCKOO_ARCH}] -- ${CUCKOO_OS} on ${QEMU_OS} " ${QEMU_OPTS}
