
. "${CUCKOO_DIR}lib/var.sh"

if [ "$CUCKOO_ACTION" = "install" ]
then
    . "${CUCKOO_DIR}lib/hd.sh"
fi


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

if [ "$QEMU_ARCH" = "x86" ] && [ "$QEMU_ARCH" != "$CUCKOO_ARCH" ]
then
    echo "ERROR: Can not run OS '${CUCKOO_ARCH}' on QEMU '${QEMU_ARCH}'"
    exit 1
fi

if [ ! -e "$QEMU_HD_DIR" ] || [ ! -d "$QEMU_HD_DIR" ]
then
    echo "ERROR: Directory '${QEMU_HD_DIR}' does not exist for HD-s"
    exit 1
fi


##  Copy in TMP_DIR

"${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -version > /dev/null
if [ $? -gt 0 ]
then
echo 123
    mkdir -p "$QEMU_TMP_DIR"

    if [ -d "$QEMU_TMP_DIR" ]
    then
        cp -rf "$QEMU_BIN_DIR" "$QEMU_TMP_DIR"

        if [ -d "${QEMU_TMP_DIR}${QEMU_VERSION}/" ]
        then
            QEMU_BIN_DIR="${QEMU_TMP_DIR}${QEMU_VERSION}/"
            chmod -R 755 "$QEMU_BIN_DIR"

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
QEMU_OPTS="-boot order="
if [ -z "$QEMU_CDROM_FILE" ] && [ "$CUCKOO_ACTION" = "run" ]
then
    QEMU_OPTS="${QEMU_OPTS}c"
else
    if [ "$CUCKOO_ACTION" = "install" ] && [ ! -z "$CUCKOO_ISO_FILE" ]
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
QEMU_OPTS="${QEMU_OPTS} -cpu ${QEMU_CPU_MODEL} -smp cpus=$((${QEMU_CPU_CORES}*${QEMU_CPU_THREADS}*${QEMU_CPU_SOCKETS})),cores=${QEMU_CPU_CORES},threads=${QEMU_CPU_THREADS},sockets=${QEMU_CPU_SOCKETS}"

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

# External(other) options
if [ ! -z "$QEMU_OPTS_EXT" ]
then
    QEMU_OPTS="${QEMU_OPTS} ${QEMU_OPTS_EXT}"
fi


"${QEMU_BIN_DIR}${QEMU_BIN_FILE}" -name " Cuckoo -- ${CUCKOO_OS}[${CUCKOO_ARCH}] on ${QEMU_OS}[${QEMU_ARCH}] " ${QEMU_OPTS}
