
CUCKOO_OS="windows"

QEMU_ISO_FILE="${QEMU_ISO_FILE:=10-en}"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/hd.sh"
. "$(realpath "$(readlink -f "$(dirname "$0")")/..")/run/$(basename $0)"
