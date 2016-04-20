
CUCKOO_DIR="$(cd "$(dirname "$0")/.." && pwd -P)/"

. "${CUCKOO_DIR}lib/default.sh"
. "${QEMU_ARCH_DIR}${CUCKOO_ACTION}/${QEMU_OS}-$(basename "$0")"
