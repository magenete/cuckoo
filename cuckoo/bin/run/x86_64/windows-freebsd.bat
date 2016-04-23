@echo off
@cls

set CUCKOO_OS=freebsd
set CUCKOO_CPU_CORES=1
set CUCKOO_CPU_THREADS=1
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=10.3

set QEMU_NO_USB=true

@call "%~dp0..\..\..\lib\run.bat" %~dp0
