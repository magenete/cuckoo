
CUCKOO_OS="freebsd"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10.3}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/}"

QEMU_CPU_CORES=1
QEMU_CPU_THREADS=1
QEMU_NO_USB="true"

. "${CUCKOO_DIR}lib/run.sh"
