@echo off
@cls

set CUCKOO_OS=freebsd
set CUCKOO_CPU_CORES=1
set CUCKOO_CPU_THREADS=1

set QEMU_NO_USB=true

@call "%~dp0..\..\..\..\lib\run.bat" %~dp0
