
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=debian/8.4}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/}"

. "${CUCKOO_DIR}lib/run.sh"
