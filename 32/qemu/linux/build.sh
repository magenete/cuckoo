#!/bin/bash

CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
TEMP_DIR="${CURRENT_DIR}/tmp"  # By default emulators are built in /tmp

QEMU_NAME="qemu"
QEMU_VERSION=""                # We build all QEMU versions listed
QEMU_BRANCH="master"           # Branch NAME in Git
QEMU_ARCH_LIST="i386-softmmu"  # What to emulate
QEMU_GIR_URL="https://github.com/${QEMU_NAME}/${QEMU_NAME}/archive/${QEMU_BRANCH}.tar.gz"
QEMU_BUILD_DIR="${TEMP_DIR}/${QEMU_NAME}-${QEMU_BRANCH}"


# Preinstall
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR

echo -e "\nSystem packages will be installed for QEMU building ...\n"

# System packages install
. /etc/os-release
case "$ID" in
    debian | ubuntu)
        sudo apt-get install -y libiscsi-dev libsdl2-dev libcap-dev libattr1-dev libpixman-1-dev flex
        ;;
    arch)
        sudo pacman -S --noconfirm libiscsi sdl libcap attr pixman flex
        ;;
    *)
        echo "WARNING: System packages were not installed for '${ID}'!"
        ;;
esac

echo -e "\nQEMU will be downloaded into ${QEMU_BUILD_DIR} folder ...\n"

# Download
cd $TEMP_DIR
curl -L $QEMU_GIR_URL | tar xz

# QEMU version definition
QEMU_VERSION="$(cat --squeeze-blank ${QEMU_BUILD_DIR}/VERSION)"

echo -e "\nQEMU ${QEMU_VERSION} will be builded into ${CURRENT_DIR} folder ...\n"

# QEMU Build
cd ${QEMU_BUILD_DIR}
./configure \
    --prefix=${CURRENT_DIR}/${QEMU_VERSION} \
    --target-list=${QEMU_ARCH_LIST} \
    --python=/usr/bin/python2 \
    --enable-sdl \
    --enable-kvm \
    --enable-vnc \
    --enable-virtfs \
    --enable-libiscsi \
    --enable-system
make && make install

# VERSION file create
printf "${QEMU_VERSION}" > "${CURRENT_DIR}/VERSION"

# Clean
rm -rf $TEMP_DIR
