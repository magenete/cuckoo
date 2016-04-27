@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


set VIRT_EMULATOR_SYSTEM=
set VIRT_EMULATOR_LIST=qemu
set VIRT_EMULATOR_DEFAULT=qemu
set VIRT_EMULATOR=


set CUCKOO_ACTION=
set CUCKOO_ACTION_DEFAULT=run
set CUCKOO_ACTION_ARCH_LIST=
set CUCKOO_ACTION_OS_LIST=
if "%CUCKOO_DIR%" == "" (
    set CUCKOO_DIR=%~dp0..\
) else (
    set CUCKOO_DIR=%CUCKOO_DIR%\
)
set CUCKOO_OS_LIST=linux netbsd freebsd openbsd macosx windows
set CUCKOO_OS_DEFAULT=linux
set CUCKOO_OS=
set CUCKOO_ARCH_LIST=x86 x86_64
set CUCKOO_ARCH=
set CUCKOO_DIST_VERSION_DEFAULT=debian/8.4
set CUCKOO_DIST_VERSION=
set CUCKOO_ISO_FILE=
set CUCKOO_ISO_FILE_NET=
set CUCKOO_ISO_FILE_PATH=
set CUCKOO_MEMORY_SIZE=
set CUCKOO_MEMORY_SIZE_DEFAULT=1G
set CUCKOO_CPU_MIN=1
set CUCKOO_CPU_CORES=
set CUCKOO_CPU_CORES_DEFAULT=4
set CUCKOO_CPU_CORES_MAX=16
set CUCKOO_CPU_THREADS=
set CUCKOO_CPU_THREADS_DEFAULT=2
set CUCKOO_CPU_THREADS_MAX=16
set CUCKOO_CPU_SOCKETS=
set CUCKOO_CPU_SOCKETS_DEFAULT=%CUCKOO_CPU_MIN%
set CUCKOO_CPU_SOCKETS_MAX=4
set CUCKOO_SETUP_DIR=
set CUCKOO_BOOT_CDROM_FILE=
set CUCKOO_BOOT_FLOPPY_FILE=
set CUCKOO_ADD_CDROM_FILE=
set CUCKOO_FULL_SCREEN=
set CUCKOO_DAEMONIZE_NO=
set CUCKOO_HD_TYPE_LIST=ide, scsi, virtio
set CUCKOO_HD_TYPE=
set CUCKOO_HD_TYPE_DEFAULT=virtio
set CUCKOO_DIST_VERSION_CONFIG=
set CUCKOO_DIST_VERSION_CONFIG_FILE=


set QEMU_ACTION=
set QEMU_ACTION_DEFAULT=run
set QEMU_ACTION_ARCH_LIST=
set QEMU_ACTION_OS_LIST=
if "%QEMU_DIR%" == "" (
    set QEMU_DIR=%CUCKOO_DIR%..\qemu\
) else (
    set QEMU_DIR=%QEMU_DIR%\
)
set QEMU_OS_LIST=linux macosx windows
set QEMU_OS=
set QEMU_ARCH_LIST=x86 x86_64
set QEMU_ARCH=


