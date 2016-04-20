
CUCKOO_OS="netbsd"
CUCKOO_ARCH="x86"
CUCKOO_CPU_CORES=1
CUCKOO_CPU_THREADS=1
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=7.0}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/}"

QEMU_NO_USB="true"
QEMU_ARCH="x86"

. "${CUCKOO_DIR}lib/run.sh"
