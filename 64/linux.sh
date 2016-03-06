
CUCKOO_OS_BIT=64
CUCKOO_CPU_CORES=4
CUCKOO_CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
CUCKOO_TMP_DIR="${TMPDIR:=/tmp}/"

QEMU_DIR="qemu"
QEMU_VERSION="2.5.0"
QEMU_RUN_DIR="${CUCKOO_CURRENT_DIR}/${QEMU_DIR}/linux/${QEMU_VERSION}"
QEMU_BIN_FILE="/bin/qemu-system-x86_64"


${QEMU_RUN_DIR}${QEMU_BIN_FILE} -version > /dev/null
if [ ! $? -eq 0 ]
then
    mkdir -p ${CUCKOO_TMP_DIR}/${QEMU_DIR}
    cp -rf $QEMU_RUN_DIR $CUCKOO_TMP_DIR/${QEMU_DIR}
    QEMU_RUN_DIR="${CUCKOO_TMP_DIR}/${QEMU_DIR}/${QEMU_VERSION}"
    chmod -R 750 $QEMU_RUN_DIR
fi

${QEMU_RUN_DIR}${QEMU_BIN_FILE} \
    -name " Cuckoo -- Linux [${CUCKOO_OS_BIT}] " \
    -boot order=c \
    --drive media=disk,if=scsi,index=0,file=${CUCKOO_CURRENT_DIR}/hd/0 \
    --drive media=disk,if=scsi,index=1,file=${CUCKOO_CURRENT_DIR}/hd/1 \
    --drive media=disk,if=scsi,index=2,file=${CUCKOO_CURRENT_DIR}/hd/2 \
    --drive media=disk,if=scsi,index=3,file=${CUCKOO_CURRENT_DIR}/hd/3 \
    --drive media=disk,if=scsi,index=4,file=${CUCKOO_CURRENT_DIR}/hd/4 \
    -m 1G \
    -cpu "qemu${CUCKOO_OS_BIT}" -smp ${CUCKOO_CPU_CORES},cores=${CUCKOO_CPU_CORES},maxcpus=${CUCKOO_CPU_CORES} \
    -vga std \
    -usb -usbdevice tablet \
    -enable-kvm \
    -daemonize
