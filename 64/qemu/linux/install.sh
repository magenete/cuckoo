#!/bin/bash

CURRENT_DIR="$(realpath $(readlink -f $(dirname $0)))"
TEMP_DIR="${CURRENT_DIR}/tmp"    # By default emulators are built in /tmp

QEMU_VERSION="2.5.0"             # We build all QEMU versions listed
QEMU_ARCH_LIST="x86_64-softmmu"  # What to emulate
QEMU_TAR_FILE="${TEMP_DIR}/qemu-${QEMU_VERSION}.tar.bz2"
QEMU_URL_FILE="http://wiki.qemu-project.org/download/$(basename $QEMU_TAR_FILE)"

echo "QEMU ${QEMU_VERSION} will be installed into ${CURRENT_DIR} folder ..."

# Preinstall
rm -rf $TEMP_DIR
mkdir -p $TEMP_DIR
# for Debian
sudo apt-get install -y libiscsi-dev libsdl-dev libcap2-dev libattr1-dev flex

# Download
cd $TEMP_DIR
wget -c $QEMU_URL_FILE
tar xvjf $QEMU_TAR_FILE

# Build
cd ${TEMP_DIR}/qemu-${QEMU_VERSION}
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

# Clean
rm -rf $TEMP_DIR
