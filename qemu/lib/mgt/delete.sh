#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Define last version if exists
qemu_delete_define_last()
{
    local version=""

    if [ -d "$QEMU_BIN_ARCH_OS_DIR" ]
    then
        for ver_dir in $(ls "$QEMU_BIN_ARCH_OS_DIR")
        do
            [ -d "$QEMU_BIN_ARCH_OS_DIR${ver_dir}" ] && version="$ver_dir"
        done

        if [ ! -z "$version" ]
        then
            printf "$version" > "$QEMU_BIN_ARCH_OS_VERSION_FILE"
        else
            rm -rf "$QEMU_BIN_ARCH_OS_DIR"

            [ -z "$(ls "$QEMU_BIN_ARCH_DIR")" ] && rm -rf "$QEMU_BIN_ARCH_DIR"
        fi
    else
        qemu_message "WAGNING: QEMU version does not exist"
    fi
}


# Delete
qemu_delete()
{
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

                qemu_delete_define_last
            else
                echo "WARNING: QEMU has not been deleted for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done

    echo ""
}
