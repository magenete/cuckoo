
CUCKOO_OS="linux"
CUCKOO_OS_BIT=32
CUCKOO_CPU_CORES=2
CUCKOO_CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"

QEMU_NAME="qemu"
QEMU_VERSION="$(cat ${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${CUCKOO_OS}/VERSION 2> /dev/null)"
QEMU_RUN_DIR="${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${CUCKOO_OS}/${QEMU_VERSION}"
QEMU_BIN_FILE="/bin/${QEMU_NAME}-system-i386"
QEMU_TMP_DIR="${CUCKOO_TMP_DIR}/${QEMU_NAME}"


# ENV check
if [ -z "$QEMU_VERSION" ]
then
    echo "ERROR: QEMU version was not defined."
    echo "Please check file '${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${CUCKOO_OS}/VERSION'."
    exit 1
fi
if [ ! -d "$QEMU_RUN_DIR" ]
then
    echo "ERROR: Directory '${QEMU_RUN_DIR}' does not exist."
    exit 1
fi
if [ ! -f "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
then
    echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist."
    exit 1
fi

# Copy in TMP_DIR
${QEMU_RUN_DIR}${QEMU_BIN_FILE} -version > /dev/null
if [ ! $? -eq 0 ]
then
    mkdir -p $QEMU_TMP_DIR

    if [ -d "$QEMU_TMP_DIR" ]
    then
        cp -rf $QEMU_RUN_DIR $QEMU_TMP_DIR

        if [ -d "${QEMU_TMP_DIR}/${QEMU_VERSION}" ]
        then
            QEMU_RUN_DIR="${QEMU_TMP_DIR}/${QEMU_VERSION}"
            chmod -R 750 $QEMU_RUN_DIR

            if [ ! -x "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
            then
                echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist."
                exit 1
            fi
        else
            echo "ERROR: Directory '${QEMU_RUN_DIR}' does not exist."
            exit 1
        fi
    else
        echo "ERROR: Directory '${QEMU_TMP_DIR}' does not exist."
        exit 1
    fi
fi

# QEMU run
${QEMU_RUN_DIR}${QEMU_BIN_FILE} \
    -name " Cuckoo -- Linux [${CUCKOO_OS_BIT}] " \
    -boot order=c \
    -drive media=disk,if=scsi,index=0,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/0 \
    -drive media=disk,if=scsi,index=1,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/1 \
    -drive media=disk,if=scsi,index=2,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/2 \
    -drive media=disk,if=scsi,index=3,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/3 \
    -drive media=disk,if=scsi,index=4,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/4 \
    -drive media=disk,if=scsi,index=5,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/5 \
    -drive media=disk,if=scsi,index=6,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/6 \
    -drive media=disk,if=scsi,index=7,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/7 \
    -m 1G \
    -cpu "${QEMU_NAME}${CUCKOO_OS_BIT}" -smp ${CUCKOO_CPU_CORES},cores=${CUCKOO_CPU_CORES},maxcpus=${CUCKOO_CPU_CORES} \
    -vga std \
    -sdl -display sdl \
    -machine mem-merge=off \
    -usb -usbdevice tablet \
    -enable-kvm \
    -daemonize