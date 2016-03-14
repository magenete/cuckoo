@echo off

set CUCKOO_OS=windows
set CUCKOO_OS_BIT=64
set CUCKOO_CPU_CORES=4
set CUCKOO_CURRENT_DIR=%~dp0
set CUCKOO_TMP_DIR=%TEMP%

set QEMU_NAME=qemu
set /P QEMU_VERSION=<%CUCKOO_CURRENT_DIR%%QEMU_NAME%\windows\VERSION
set QEMU_RUN_DIR=%CUCKOO_CURRENT_DIR%%QEMU_NAME%\windows\%QEMU_VERSION%
set QEMU_BIN_FILE=\%QEMU_NAME%-system-x86_64w.exe
set QEMU_TMP_DIR=%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%


    echo ERROR: Directory '%QEMU_RUN_DIR%' does not exist.
    exit 1
