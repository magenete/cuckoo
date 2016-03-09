
CUCKOO_OS="linux"
CUCKOO_OS_BIT=64
CUCKOO_CPU_CORES=4
CUCKOO_CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"

QEMU_NAME="qemu"
QEMU_VERSION="2.5.0"
QEMU_RUN_DIR="${CUCKOO_CURRENT_DIR}/${QEMU_NAME}/${CUCKOO_OS}/${QEMU_VERSION}"
QEMU_BIN_FILE="/bin/${QEMU_NAME}-system-x86_64"


${QEMU_RUN_DIR}${QEMU_BIN_FILE} -version > /dev/null
if [ ! $? -eq 0 ]
then
    mkdir -p ${CUCKOO_TMP_DIR}/${QEMU_NAME}
    cp -rf $QEMU_RUN_DIR $CUCKOO_TMP_DIR/${QEMU_NAME}
    QEMU_RUN_DIR="${CUCKOO_TMP_DIR}/${QEMU_NAME}/${QEMU_VERSION}"
    chmod -R 750 $QEMU_RUN_DIR
fi

${QEMU_RUN_DIR}${QEMU_BIN_FILE} \
    -name " Cuckoo -- Linux [${CUCKOO_OS_BIT}] " \
    -boot order=c \
    --drive media=disk,if=scsi,index=0,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/0 \
    --drive media=disk,if=scsi,index=1,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/1 \
    --drive media=disk,if=scsi,index=2,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/2 \
    --drive media=disk,if=scsi,index=3,file=${CUCKOO_CURRENT_DIR}/hd/${CUCKOO_OS}/3 \
    -m 1G \
    -cpu "${QEMU_NAME}${CUCKOO_OS_BIT}" -smp ${CUCKOO_CPU_CORES},cores=${CUCKOO_CPU_CORES},maxcpus=${CUCKOO_CPU_CORES} \
    -vga std \
    -display sdl \
    -machine mem-merge=off \
    -usb -usbdevice tablet \
    -enable-kvm \
    -daemonize
