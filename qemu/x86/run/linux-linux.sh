
CUCKOO_ARCH="x86"
CUCKOO_CPU_CORES=2
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=debian-8.4}"

QEMU_ARCH="i386"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/run.sh"
