
CUCKOO_OS_BIT=$(getconf LONG_BIT 2>/dev/null)
CUCKOO_CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
CUCKOO_CURRENT_FILE="$(basename $0)"

sh ${CUCKOO_CURRENT_DIR}/${CUCKOO_OS_BIT}/${CUCKOO_CURRENT_FILE}
