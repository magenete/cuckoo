
QEMU_OS=""


case $(uname -m) in
    x86_64 | amd64 )
        QEMU_ARCH="${QEMU_ARCH:=x86_64}"
    ;;
    x86 | i386 | i486 | i586 | i686 )
        QEMU_ARCH="${QEMU_ARCH:=x86}"
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
#    NetBSD )
#        QEMU_OS="netbsd"
#    ;;
#    OpenBSD )
#        QEMU_OS="openbsd"
#    ;;
#    FreeBSD )
#        QEMU_OS="freebsd"
#    ;;
    * )
        echo "ERROR: Current system does not supported"
        exit 1
    ;;
esac
