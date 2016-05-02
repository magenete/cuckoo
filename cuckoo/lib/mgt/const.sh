#
# A desktop-oriented virtual machines management system written in Shell.
#
# Code is available online at https://github.com/magenete/cuckoo
# See LICENSE for licensing information, and README for details.
#
# Copyright (C) 2016 Magenete Systems OÜ.
#


VIRT_EMULATOR_LIST="qemu"
VIRT_EMULATOR_DEFAULT="qemu"


CUCKOO_ACTION_DEFAULT="run"
CUCKOO_OS_LIST="linux netbsd freebsd openbsd macosx windows"
CUCKOO_OS_DEFAULT="linux"
CUCKOO_ARCH_LIST="x86 x86_64"
CUCKOO_DIST_VERSION_DEFAULT="debian/8.4"
CUCKOO_MEMORY_SIZE_DEFAULT="1G"
CUCKOO_CPU_MIN=1
CUCKOO_CPU_CORES_DEFAULT=4
CUCKOO_CPU_CORES_MAX=16
CUCKOO_CPU_THREADS_DEFAULT=2
CUCKOO_CPU_THREADS_MAX=16
CUCKOO_CPU_SOCKETS_DEFAULT=$CUCKOO_CPU_MIN
CUCKOO_CPU_SOCKETS_MAX=4
CUCKOO_HD_TYPE_LIST="ide, scsi, virtio"
CUCKOO_HD_TYPE_DEFAULT="virtio"
