
CUCKOO_OS="netbsd"
CUCKOO_OS_BIT=32
CUCKOO_CPU_CORES=1
CUCKOO_CPU_THREADS=1

QEMU_NO_USB="true"
QEMU_ARCH="i386"

. "$(realpath $(readlink -f $(dirname $0)))/../lib/run.sh"
