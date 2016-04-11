
CUCKOO_OS="windows"
CUCKOO_OS_BIT=32
CUCKOO_CPU_CORES=2

QEMU_OS="macosx"
QEMU_ARCH="i386"

. "$(cd "$(dirname "$0")" && pwd -P)/../lib/run.sh"

cuckoo_manufacturer_not_supported
