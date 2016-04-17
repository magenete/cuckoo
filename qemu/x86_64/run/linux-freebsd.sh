
CUCKOO_OS="freebsd"
CUCKOO_CPU_CORES=1
CUCKOO_CPU_THREADS=1

QEMU_NO_USB="true"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/run.sh"
