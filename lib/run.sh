
. "${CUCKOO_DIR}lib/default.sh"

CUCKOO_ISO_DIR="${CUCKOO_DIR}install/iso/${CUCKOO_ARCH}/${CUCKOO_OS}/"

QEMU_VERSION_FILE="${CUCKOO_DIR}qemu/${QEMU_ARCH}/bin/${QEMU_OS}/VERSION"
QEMU_VERSION="$(cat "$QEMU_VERSION_FILE" 2> /dev/null)"
QEMU_BIN_DIR="${CUCKOO_DIR}qemu/${QEMU_ARCH}/bin/${QEMU_OS}/${QEMU_VERSION}/"
QEMU_TMP_DIR="${CUCKOO_TMP_DIR}qemu/"
QEMU_HD_DIR="${CUCKOO_DIR}qemu/${CUCKOO_ARCH}/hd/${CUCKOO_OS}/${CUCKOO_DIST_VERSION_DIR}"
QEMU_BIN_FILE="bin/qemu-system-${QEMU_ARCH}"


##  ENV check

if [ -z "$QEMU_VERSION" ]
then
    echo "ERROR: QEMU version was not defined"
    echo "Please check file '${QEMU_VERSION_FILE}'"
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
QEMU_OPTS="${QEMU_OPTS} -cpu ${QEMU_CPU_MODEL} -smp cpus=$((${CUCKOO_CPU_CORES}*${CUCKOO_CPU_THREADS}*${CUCKOO_CPU_SOCKETS})),cores=${CUCKOO_CPU_CORES},threads=${CUCKOO_CPU_THREADS},sockets=${CUCKOO_CPU_SOCKETS}"

# Drive
for qemu_disk in $(ls $QEMU_HD_DIR)
do
    if [ -f "${QEMU_HD_DIR}${qemu_disk}" ]
    then
        QEMU_OPTS="${QEMU_OPTS} -drive media=disk,if=${QEMU_HD_TYPE},index=${qemu_disk},file=${QEMU_HD_DIR}${qemu_disk}"
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


"${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -name " Cuckoo -- ${CUCKOO_OS}[${CUCKOO_ARCH}] on ${QEMU_OS}[${QEMU_ARCH}] " ${QEMU_OPTS}
