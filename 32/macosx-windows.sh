
CUCKOO_OS="windows"
CUCKOO_OS_BIT=32
CUCKOO_CPU_CORES=2

QEMU_OS="macosx"
QEMU_ARCH="i386"

. $(realpath $(readlink -f $(dirname $0)))/../lib/run.sh

cuckoo_manufacturer_not_supported
