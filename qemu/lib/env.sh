
case $(uname -m) in
    x86_64 | amd64 )
        QEMU_ARCH="${QEMU_ARCH:=x86_64}"
    ;;
    x86 | i386 | i486 | i586 | i686 )
        QEMU_ARCH="${QEMU_ARCH:=x86}"
    ;;
    * )
        echo "ERROR: Current OS architecture has not been supported for QEMU"
        exit 1
    ;;
esac


case $(uname -s) in
    Linux )
        if [ -z "$QEMU_OS_REAL" ]
        then
            QEMU_OS="${QEMU_OS:=linux}"
        else
            QEMU_OS="linux"
        fi
    ;;
    Darwin )
        if [ -z "$QEMU_OS_REAL" ]
        then
            QEMU_OS="${QEMU_OS:=macosx}"
        else
            QEMU_OS="macosx"
        fi
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
        echo "ERROR: Current OS does not supported for QEMU"
        exit 1
    ;;
esac
