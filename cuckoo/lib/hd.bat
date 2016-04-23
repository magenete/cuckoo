@echo off

if "%CUCKOO_OS%" == "" set CUCKOO_OS=linux
if "%CUCKOO_DIST_VERSION%" == "" (
    set CUCKOO_DIST_VERSION=%CUCKOO_ISO_FILE%
)
if "%CUCKOO_DIST_VERSION%" == "" (
    set CUCKOO_DIST_VERSION_DIR=
) else (
    set CUCKOO_DIST_VERSION_DIR=%CUCKOO_DIST_VERSION%\
)
set QEMU_HD_DIR=%1..\hd\%CUCKOO_OS%\
set QEMU_HD_CLEAN_DIR=%QEMU_HD_DIR%clean\


if not exist "%QEMU_HD_CLEAN_DIR%" (
    @echo ERROR: Directory '%QEMU_HD_CLEAN_DIR%' does not exist
    @pause
    @exit 1
)


if "%CUCKOO_DIST_VERSION%" == "" (
    setlocal EnableDelayedExpansion
    for /F "usebackq" %%f in (`dir /A-D /O /B "%QEMU_HD_DIR%"`) do (
        @del /Q "%QEMU_HD_DIR%%%f"
    )
) else (
    if exist "%QEMU_HD_DIR%%CUCKOO_DIST_VERSION_DIR%" (
        @rmdir /S /Q "%QEMU_HD_DIR%%CUCKOO_DIST_VERSION_DIR%" > nul
    )
    @mkdir "%QEMU_HD_DIR%%CUCKOO_DIST_VERSION_DIR%" > nul
)

setlocal EnableDelayedExpansion
for /F "usebackq" %%f in (`dir /A-D /O /B "%QEMU_HD_CLEAN_DIR%"`) do (
    @copy /Y "%QEMU_HD_CLEAN_DIR%%%f" "%QEMU_HD_DIR%%CUCKOO_DIST_VERSION_DIR%%%f" > nul
)
