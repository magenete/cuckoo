@echo off
@cls

set CUCKOO_ARCH=x86
set CUCKOO_CPU_CORES=2
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=debian-8.4

set QEMU_ARCH=i386

@call "%~dp0..\..\..\lib\run.bat" %~dp0
