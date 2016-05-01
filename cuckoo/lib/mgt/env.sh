#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Cuckoo environment
cuckoo_env()
{
    case $(uname -m) in
        x86_64 | amd64 )
            CUCKOO_ARCH="${CUCKOO_ARCH:=x86_64}"
        ;;
        x86 | i386 | i486 | i586 | i686 | i786 )
            CUCKOO_ARCH="${CUCKOO_ARCH:=x86}"
        ;;
        * )
            cuckoo_error "Current OS architecture is not supported"
        ;;
    esac
}
