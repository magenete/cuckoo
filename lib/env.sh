
CUCKOO_ACTION="${CUCKOO_ACTION:=run}"

QEMU_ARCH=""
QEMU_OS=""


if [ -z "$CUCKOO_DIR" ]
then
    echo "ERROR: Cuckoo directory (variable CUCKOO_DIR) has not been defined"
    exit 1
fi


case $(uname -m) in
    x86_64 | amd64 )
        QEMU_ARCH="x86_64"
    ;;
    x86 | i386 | i486 | i586 | i686 )
        QEMU_ARCH="x86"
    ;;
    * )
        echo "ERROR: Current system architecture has not been supported"
        exit 1
    ;;
esac


case $(uname -s) in
    Linux )
        QEMU_OS="linux"
    ;;
    Darwin )
        QEMU_OS="macosx"
    ;;
    NetBSD )
        QEMU_OS="netbsd"
    ;;
    OpenBSD )
        QEMU_OS="openbsd"
    ;;
    FreeBSD )
        QEMU_OS="freebsd"
    ;;
    * )
        echo "ERROR: Current system does not supported"
        exit 1
    ;;
esac


CUCKOO_ACTION_FILE="${CUCKOO_DIR}qemu/${QEMU_ARCH}/${CUCKOO_ACTION}/${QEMU_OS}-$(basename "$0")"
