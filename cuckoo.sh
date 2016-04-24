
CUCKOO_DIR="${CUCKOO_DIR:=$(cd "$(dirname "$0")" && pwd -P)/cuckoo}"

. "${CUCKOO_DIR}/manage.sh" $@
