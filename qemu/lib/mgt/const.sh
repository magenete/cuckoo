#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


QEMU_ACTION_DEFAULT="run"
QEMU_OS_LIST="linux macosx windows"
QEMU_OS_DEFAULT="linux"
QEMU_ARCH_LIST="x86 x86_64"
QEMU_ARCH_DEFAULT="x86_64"
QEMU_HD_TYPE_LIST="ide scsi virtio"
QEMU_HD_TYPE_DEFAULT="virtio"
QEMU_CPU_CORES_DEFAULT=4
QEMU_CPU_THREADS_DEFAULT=2
QEMU_CPU_SOCKETS_DEFAULT=1
QEMU_MEMORY_SIZE_DEFAULT="1G"

QEMU_BUILD_SOURCE_URL_DIR="https://github.com/qemu/qemu/archive/"
QEMU_BUILD_BRANCH_DEFAULT="master"
