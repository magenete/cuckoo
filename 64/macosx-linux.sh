
CUCKOO_OS="macosx"

. $(realpath $(readlink -f $(dirname $0)))/../utils.sh

cuckoo_qemu_check_env
cuckoo_qemu_copy_to_tmp
cuckoo_qemu_run
