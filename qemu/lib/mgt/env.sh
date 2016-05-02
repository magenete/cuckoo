#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Environment
qemu_env()
{
    case $(uname -m) in
        x86_64 | amd64 )
            QEMU_ARCH="${QEMU_ARCH:=x86_64}"
        ;;
        x86 | i386 | i486 | i586 | i686 | i786 )
            QEMU_ARCH="${QEMU_ARCH:=x86}"
        ;;
        * )
            qemu_error "Current OS architecture has not been supported for QEMU"
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
#        NetBSD )
#            QEMU_OS="netbsd"
#        ;;
#        OpenBSD )
#            QEMU_OS="openbsd"
#        ;;
#        FreeBSD )
#            QEMU_OS="freebsd"
#        ;;
        * )
            qemu_error "Current OS does not supported for QEMU"
        ;;
    esac
}
