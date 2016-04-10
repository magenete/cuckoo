
CUCKOO_OS="${CUCKOO_OS:=linux}"
CUCKOO_OS_BIT=${CUCKOO_OS_BIT:=64}
CUCKOO_CPU_CORES=${CUCKOO_CPU_CORES:=4}
CUCKOO_CPU_THREADS=${CUCKOO_CPU_THREADS:=2}
CUCKOO_CPU_SOCKETS=${CUCKOO_CPU_SOCKETS:=1}
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"
CUCKOO_CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"

QEMU_NAME="qemu"
QEMU_OS="${QEMU_OS:=linux}"
QEMU_ARCH="${QEMU_ARCH:=x86_64}"
QEMU_CDROM="${QEMU_CDROM:=}"
QEMU_MEMORY_SIZE="${QEMU_MEMORY_SIZE:=1G}"
QEMU_VERSION="$(cat ${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${QEMU_OS}/VERSION 2> /dev/null)"
QEMU_RUN_DIR="${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${QEMU_OS}/${QEMU_VERSION}"
QEMU_BIN_FILE="/bin/${QEMU_NAME}-system-${QEMU_ARCH}"
QEMU_TMP_DIR="${CUCKOO_TMP_DIR}/${QEMU_NAME}"
QEMU_HD_DIR="${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/"
QEMU_OPTS="${QEMU_OPTS:=}"


# ENV check
cuckoo_qemu_check_env()
{
    if [ -z "$QEMU_VERSION" ]
    then
        echo "ERROR: QEMU version was not defined"
        echo "Please check file '${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${QEMU_OS}/VERSION'"
        exit 1
    fi

    if [ ! -d "$QEMU_RUN_DIR" ]
    then
        echo "ERROR: Directory '${QEMU_RUN_DIR}' does not exist"
        exit 1
    fi

    if [ ! -f "${QEMU_RUN_DIR}${QEMU_BIN_FILE}" ]
    then
        echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
        exit 1
    fi
}

# Copy in TMP_DIR
cuckoo_qemu_copy_to_tmp()
{
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
                    echo "ERROR: File '${QEMU_RUN_DIR}${QEMU_BIN_FILE}' does not exist"
                    exit 1
                fi
            else
                echo "ERROR: Directory '${QEMU_TMP_DIR}/${QEMU_VERSION}' does not exist"
                exit 1
            fi
        else
            echo "ERROR: Directory '${QEMU_TMP_DIR}' does not exist"
            exit 1
        fi
    fi
}

# QEMU run
cuckoo_qemu_run()
{
    # Bootloading and CDROM
    if [ -z $QEMU_CDROM ]
    then
        QEMU_OPTS="${QEMU_OPTS} -boot order=c"
    else
        QEMU_OPTS="${QEMU_OPTS} -boot order=d -cdrom ${QEMU_CDROM}"
    fi

    # Memory
    QEMU_OPTS="${QEMU_OPTS} -m ${QEMU_MEMORY_SIZE} -balloon virtio"

    # CPU
    QEMU_OPTS="${QEMU_OPTS} -cpu ${QEMU_NAME}${CUCKOO_OS_BIT} -smp cpus=$((${CUCKOO_CPU_CORES}*${CUCKOO_CPU_THREADS}*${CUCKOO_CPU_SOCKETS})),cores=${CUCKOO_CPU_CORES},threads=${CUCKOO_CPU_THREADS},sockets=${CUCKOO_CPU_SOCKETS}"

    # Dirve
    for qemu_disk in $(ls $QEMU_HD_DIR)
    do
        if [ -f ${QEMU_HD_DIR}${qemu_disk} ]
        then
            QEMU_OPTS="${QEMU_OPTS} -drive media=disk,if=virtio,index=${qemu_disk},file=${QEMU_HD_DIR}${qemu_disk}"
        fi
    done

    # Screen
    QEMU_OPTS="${QEMU_OPTS} -vga std -sdl -display sdl"

    # USB
    QEMU_OPTS="${QEMU_OPTS} -usb -usbdevice tablet -device piix3-usb-uhci"

    # KVM
    QEMU_OPTS="${QEMU_OPTS} -enable-kvm"

    # Daemonize
    QEMU_OPTS="${QEMU_OPTS} -daemonize"

    ${QEMU_RUN_DIR}${QEMU_BIN_FILE} -name " Cuckoo [${CUCKOO_OS_BIT}] -- ${CUCKOO_OS} on ${QEMU_OS} " ${QEMU_OPTS}
}
