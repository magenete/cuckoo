#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Delete
qemu_delete()
{
    QEMU_ENV_NO="yes"

    echo ""
    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_ARCH="$qemu_arch"
            QEMU_OS="$qemu_os"

            qemu_variables

            if [ -d "$QEMU_BIN_ARCH_OS_VERSION_DIR" ]
            then
                rm -rf "$QEMU_BIN_ARCH_OS_VERSION_DIR"

                echo "QEMU has been deleted in '${QEMU_BIN_ARCH_OS_VERSION_DIR}'"
            else
                echo "WARNING: QEMU has not been deleted for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done
    echo ""
}
