
CUCKOO_ISO_FILE="${CUCKOO_ISO_FILE:=debian-8.4}"

. "$(realpath "$(readlink -f "$(dirname "$0")")/../../..")/lib/hd.sh"
. "$(realpath "$(readlink -f "$(dirname "$0")")/..")/run/$(basename $0)"
