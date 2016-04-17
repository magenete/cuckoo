
CUCKOO_OS="openbsd"
CUCKOO_CPU_CORES=1
CUCKOO_CPU_THREADS=1
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=5.9}"

QEMU_NO_USB="true"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/run.sh"
