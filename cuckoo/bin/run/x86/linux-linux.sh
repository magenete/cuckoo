
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=debian-8.4}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")}"

"${CUCKOO_DIR}/manage.sh" --run --arch x86 --os-name linux --dist-version $CUCKOO_DIST_VERSION --cpu-cores 2
