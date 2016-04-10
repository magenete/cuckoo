
CUCKOO_OS_BIT=32
CUCKOO_CPU_CORES=2

QEMU_ARCH="i386"

. $(realpath $(readlink -f $(dirname $0)))/../lib/run.sh

cuckoo_qemu_check_env
cuckoo_qemu_copy_to_tmp
cuckoo_qemu_run
