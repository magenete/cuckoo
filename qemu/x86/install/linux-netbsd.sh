
CUCKOO_OS="netbsd"

QEMU_ISO_FILE="${QEMU_ISO_FILE:=7.0}"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/hd.sh"
. "$(realpath "$(readlink -f "$(dirname "$0")")/..")/run/$(basename $0)"
