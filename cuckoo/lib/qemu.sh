
QEMU_SYSTEM="${CUCKOO_VIRT_EMULATOR_SYSTEM:=}"
QEMU_HD_TYPE="${CUCKOO_HD_TYPE:=virtio}"
QEMU_CPU_CORES=${CUCKOO_CPU_CORES:=4}
QEMU_CPU_THREADS=${CUCKOO_CPU_THREADS:=2}
QEMU_CPU_SOCKETS=${CUCKOO_CPU_SOCKETS:=1}
QEMU_SMB_DIR="${CUCKOO_SMB_DIR:=}"
QEMU_FULL_SCREEN="${CUCKOO_FULL_SCREEN:=}"
QEMU_NO_DAEMONIZE="${CUCKOO_NO_DAEMONIZE:=}"
QEMU_MEMORY_SIZE="${CUCKOO_MEMORY_SIZE:=1G}"

QEMU_BOOT_CDROM_FILE="$CUCKOO_BOOT_CDROM_FILE"
QEMU_BOOT_FLOPPY_FILE="$CUCKOO_BOOT_FLOPPY_FILE"
QEMU_ADD_CDROM_FILE="$CUCKOO_ADD_CDROM_FILE"
QEMU_HD_DIR="${CUCKOO_HD_ARCH_OS_DIR}${CUCKOO_DIST_VERSION_DIR}"
QEMU_TITLE=" Cuckoo -- ${CUCKOO_OS}[${CUCKOO_ARCH}] on ${QEMU_OS}[${QEMU_ARCH}] "
QEMU_OPTS_EXT="$CUCKOO_OPTS_EXT"
