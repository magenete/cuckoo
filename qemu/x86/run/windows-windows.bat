@echo off
@cls

set CUCKOO_OS=windows
set CUCKOO_OS_BIT=32
set CUCKOO_CPU_CORES=2

set QEMU_ARCH=i386

@call "%~dp0..\lib\run.bat" %~dp0
