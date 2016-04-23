
CUCKOO_OS="windows"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10/en}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/}"

. "${CUCKOO_DIR}lib/run.sh"
