
CUCKOO_ACTION="${CUCKOO_ACTION:=--run}"
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10/en}"
CUCKOO_DIR="$(cd "$(dirname "$0")/.." && pwd -P)"

. "${CUCKOO_DIR}/manage.sh" $CUCKOO_ACTION --os-name $(basename $0 .sh) --dist-version $CUCKOO_DIST_VERSION $@
