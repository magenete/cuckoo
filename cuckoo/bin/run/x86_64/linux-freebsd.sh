
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=10.3}"
CUCKOO_DIR="${CUCKOO_DIR:=$(realpath "$(readlink -f "$(dirname "$0")")/../../..")}"

"${CUCKOO_DIR}/manage.sh" --run --arch x86_64 --os-name freebsd --dist-version $CUCKOO_DIST_VERSION --cpu-cores 1 --cpu-threads 1
