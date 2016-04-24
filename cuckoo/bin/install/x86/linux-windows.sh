
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10-en}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")}"

"${CUCKOO_DIR}/manage.sh" --install --arch x86 --os-name windows --dist-version $CUCKOO_DIST_VERSION --cpu-cores 2
