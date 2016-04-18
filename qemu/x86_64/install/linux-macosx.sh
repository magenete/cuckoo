
CUCKOO_OS="macosx"
CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE:=10.11}"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/hd.sh"
. "$(realpath "$(readlink -f "$(dirname "$0")")/..")/run/$(basename $0)"
