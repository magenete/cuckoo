#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Setup
qemu_setup()
{
    QEMU_ENV_NO="yes"

    for qemu_arch in $QEMU_ACTION_ARCH_LIST
    do
        for qemu_os in $QEMU_ACTION_OS_LIST
        do
            QEMU_OS="$qemu_os"
            QEMU_ARCH="$qemu_arch"

            qemu_variables

            if [ -d "$QEMU_BIN_ARCH_OS_DIR" ]
            then
                mkdir -p "${QEMU_SETUP_DIR}qemu/bin/${QEMU_ARCH}/${QEMU_OS}/"
                cp -rv "$QEMU_BIN_ARCH_OS_DIR" "${QEMU_SETUP_DIR}qemu/bin/${QEMU_ARCH}/"

                echo "      ...from '${QEMU_BIN_ARCH_OS_DIR}'"
            else
                echo "WARNING: QEMU not copyed for OS: ${qemu_os}, arch: ${qemu_arch}"
            fi
        done
    done

    qemu_message "Cuckoo was set in '${QEMU_SETUP_DIR}'"
}


# Setup directory
qemu_setup_dir()
{
    echo ""
    echo "  Directory qemu/: copying..."
    mkdir "${QEMU_SETUP_DIR}qemu/"

    echo ""
    echo "    Directory lib/: copying..."
    cp -rv "${QEMU_DIR}lib/" "${QEMU_SETUP_DIR}qemu/"

    echo ""
    echo "    Directory bin/: copying..."
    mkdir "${QEMU_SETUP_DIR}qemu/bin/"
    echo ""
}
