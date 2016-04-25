#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


case $(uname -m) in
    x86_64 | amd64 )
        CUCKOO_ARCH="${CUCKOO_ARCH:=x86_64}"
    ;;
    x86 | i386 | i486 | i586 | i686 )
        CUCKOO_ARCH="${CUCKOO_ARCH:=x86}"
    ;;
    * )
        echo "ERROR: Current OS architecture has not been supported"
        exit 1
    ;;
esac
