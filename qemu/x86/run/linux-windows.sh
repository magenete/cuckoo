
CUCKOO_OS="windows"
CUCKOO_ARCH="x86"
CUCKOO_CPU_CORES=2
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10-en}"

QEMU_ARCH="i386"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/run.sh"
