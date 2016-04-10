
CUCKOO_OS="netbsd"
CUCKOO_CPU_CORES=1
CUCKOO_CPU_THREADS=1

. $(realpath $(readlink -f $(dirname $0)))/../utils.sh

cuckoo_qemu_check_env
cuckoo_qemu_copy_to_tmp
cuckoo_qemu_run
