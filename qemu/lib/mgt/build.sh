#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


# Build launch
qemu_build_launch()
(
    # Preinstall
    rm -rf "$QEMU_BIN_ARCH_OS_TMP_DIR"
    mkdir -p "$QEMU_BIN_ARCH_OS_TMP_DIR"

    # Download
    qemu_message "QEMU will be downloaded into '${QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR}' folder ..."

    cd "$QEMU_BIN_ARCH_OS_TMP_DIR"
    curl -SL "$QEMU_BUILD_SOURCE_URL_FILE" | tar -vxz

    # Version definition
    QEMU_BIN_ARCH_OS_VERSION="$(cat -s "${QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR}/VERSION")"
    QEMU_BIN_ARCH_OS_VERSION_DIR="${QEMU_BIN_ARCH_OS_DIR}${QEMU_BIN_ARCH_OS_VERSION}/"

    # Build
    qemu_message "QEMU '${QEMU_BIN_ARCH_OS_VERSION}' will be builded into '${QEMU_BIN_ARCH_OS_VERSION_DIR}' folder ..."

    cd "${QEMU_BIN_ARCH_OS_TMP_BRANCH_DIR}"
    ./configure \
        --prefix=${QEMU_BIN_ARCH_OS_DIR}${QEMU_BIN_ARCH_OS_VERSION} \
        --target-list=${QEMU_BUILD_ARCH_TARGET} \
        --python=/usr/bin/python2 \
        --enable-sdl \
        --enable-kvm \
        --enable-vnc \
        --enable-virtfs \
        --enable-libiscsi \
        --enable-system
    make && make install

    # VERSION file create
    printf "${QEMU_BIN_ARCH_OS_VERSION}" > "$QEMU_BIN_ARCH_OS_VERSION_FILE"

    # Clean
    rm -rf "$QEMU_BIN_ARCH_OS_TMP_DIR"
)


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

            mkdir -p "$QEMU_BIN_ARCH_OS_DIR"

            qemu_build_launch
            if [ $? -gt 0 ]
            then
                qemu_error "QEMU has not been buit for OS: ${qemu_os}, arch: ${qemu_arch}"
            else
                qemu_variables

                qemu_message "QEMU has been buit in '${QEMU_BIN_ARCH_OS_VERSION_DIR}'"
            fi
        done
    done
}
