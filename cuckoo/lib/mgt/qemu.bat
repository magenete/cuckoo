@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


set QEMU_SYSTEM=%VIRT_EMULATOR_SYSTEM%
set QEMU_HD_TYPE=%CUCKOO_HD_TYPE%
set QEMU_CPU_CORES=%CUCKOO_CPU_CORES%
set QEMU_CPU_THREADS=%CUCKOO_CPU_THREADS%
set QEMU_CPU_SOCKETS=%CUCKOO_CPU_SOCKETS%
set QEMU_SMB_DIR=%CUCKOO_SMB_DIR%
set QEMU_FULL_SCREEN=%CUCKOO_FULL_SCREEN%
set QEMU_DAEMONIZE_NO=%CUCKOO_DAEMONIZE_NO%
set QEMU_MEMORY_SIZE=%CUCKOO_MEMORY_SIZE%

set QEMU_BOOT_CDROM_FILE=%CUCKOO_BOOT_CDROM_FILE%
set QEMU_BOOT_FLOPPY_FILE=%CUCKOO_BOOT_FLOPPY_FILE%
set QEMU_ADD_CDROM_FILE=%CUCKOO_ADD_CDROM_FILE%
set QEMU_HD_DIR=%CUCKOO_HD_ARCH_OS_DIR%%CUCKOO_DIST_VERSION_DIR%
set QEMU_TITLE= Cuckoo -- %CUCKOO_OS%[%CUCKOO_ARCH%] on %QEMU_OS%[%QEMU_ARCH%] 
set QEMU_OPTS_EXT=%CUCKOO_OPTS_EXT%
