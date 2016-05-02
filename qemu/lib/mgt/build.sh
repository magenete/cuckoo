#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Build
qemu_build()
{
    QEMU_ENV_NO="yes"

    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_ARCH="$qemu_arch"
            QEMU_OS="$qemu_os"

            qemu_variables

            if [ -f "$QEMU_BUILD_ARCH_OS_FILE" ]
            then
                . "$QEMU_BUILD_ARCH_OS_FILE"

                qemu_message "QEMU has been buit in '${QEMU_BIN_ARCH_OS_VERSION_DIR}'"
            else
                qemu_message "WARNING: QEMU has not been buit for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done
}
