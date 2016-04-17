
CUCKOO_OS="openbsd"

QEMU_ISO_FILE="${QEMU_ISO_FILE:=5.9}"

.  "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/hd.sh"
. "$(realpath "$(readlink -f "$(dirname "$0")")/..")/run/$(basename $0)"
