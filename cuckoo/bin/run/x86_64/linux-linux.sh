
CUCKOO_DIST_VERSION="${CUCKOO_DIST_VERSION:=debian/8.4}"
CUCKOO_DIR="$(cd "$(dirname "$0")/../../.." && pwd -P)/"

cd "${CUCKOO_DIR}../" && . "${CUCKOO_DIR}../cuckoo.sh" --run --os-name linux --dist-version $CUCKOO_DIST_VERSION
