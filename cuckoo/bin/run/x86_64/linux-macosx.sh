
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10.11}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")}"

"${CUCKOO_DIR}/manage.sh" --run --arch x86_64 --os-name macosx --dist-version $CUCKOO_DIST_VERSION
