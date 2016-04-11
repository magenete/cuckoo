
CUCKOO_OS="openbsd"
CUCKOO_CPU_CORES=1
CUCKOO_CPU_THREADS=1

. "$(realpath $(readlink -f $(dirname $0)))/../lib/run.sh"

cuckoo_qemu_check_env
cuckoo_qemu_copy_to_tmp
cuckoo_qemu_run
