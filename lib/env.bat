@echo off
@cls

wmic os get osarchitecture | findstr /i "64" > nul
if %ERRORLEVEL% == 0 (
    set CUCKOO_OS_BIT=x86_64
) else (
    set CUCKOO_OS_BIT=x86
)

if "%2" == "" (
    @echo ERROR: Current system does not supported
    @pause
    @exit 1
) else (
    set QEMU_OS=%2
)

if "%1" == "" (
    @echo ERROR: Current directory has not been defined
    @pause
    @exit 1
) else (
    set CUCKOO_CURRENT_DIR=%1
)

@call "%CUCKOO_CURRENT_DIR%%CUCKOO_OS_BIT%\run\windows-%QEMU_OS%"
