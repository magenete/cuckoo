@echo off
@cls

set CUCKOO_OS=openbsd
set CUCKOO_OS_BIT=32
set CUCKOO_CPU_CORES=1
set CUCKOO_CPU_THREADS=1

set QEMU_NO_USB=true
set QEMU_ARCH=i386

@call "%~dp0..\lib\run.bat" %~dp0
