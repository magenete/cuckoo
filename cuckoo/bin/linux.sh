
CUCKOO_DIR="$(cd "$(dirname "$0")/.." && pwd -P)/"

cd "${CUCKOO_DIR}../" && . "${CUCKOO_DIR}../cuckoo.sh" -o linux
