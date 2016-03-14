
CUCKOO_OS="macosx"
CUCKOO_OS_BIT=64
CUCKOO_CPU_CORES=4
CUCKOO_CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"

QEMU_OS="linux"
QEMU_NAME="qemu"
QEMU_VERSION="$(cat ${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${QEMU_OS}/VERSION 2> /dev/null)"
QEMU_RUN_DIR="${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${QEMU_OS}/${QEMU_VERSION}"
QEMU_BIN_FILE="/bin/${QEMU_NAME}-system-x86_64"
QEMU_TMP_DIR="${CUCKOO_TMP_DIR}/${QEMU_NAME}"


# ENV check
if [ -z "$QEMU_VERSION" ]
then
    echo "ERROR: QEMU version was not defined."
    echo "Please check file '${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${QEMU_OS}/VERSION'."
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

        if [ -d "${QEMU_RUN_DIR}/${QEMU_VERSION}" ]
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

echo "ERROR: Not implemented"
exit 1
