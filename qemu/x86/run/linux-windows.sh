
CUCKOO_OS="windows"
CUCKOO_ARCH="x86"
CUCKOO_CPU_CORES=2
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10-en}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/}"

QEMU_ARCH="x86"

. "${CUCKOO_DIR}lib/run.sh"
