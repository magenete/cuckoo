#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Print error message and exit
qemu_error()
{
    echo ""
    echo "ERROR: ${1}"
    [ ! -z "$2" ] && echo "$2"
    echo ""

    exit 1
}


# Print message
qemu_message()
{
    echo ""
    echo "$1"
    [ ! -z "$2" ] && echo "$2"
    echo ""
}
