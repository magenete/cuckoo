@echo off
@cls

set CUCKOO_OS=netbsd
set CUCKOO_ARCH=x86
set CUCKOO_CPU_CORES=1
set CUCKOO_CPU_THREADS=1
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=7.0

set QEMU_NO_USB=true
set QEMU_ARCH=i386

@call "%~dp0..\..\..\lib\run.bat" %~dp0
