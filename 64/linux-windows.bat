@echo off

set CUCKOO_OS=linux
set CUCKOO_OS_BIT=64
set CUCKOO_CPU_CORES=4
set CUCKOO_CURRENT_DIR=%~dp0
set CUCKOO_TMP_DIR=%TEMP%

set QEMU_OS=windows
set QEMU_NAME=qemu
set /P QEMU_VERSION=<%CUCKOO_CURRENT_DIR%%QEMU_NAME%\%QEMU_OS%\VERSION
set QEMU_RUN_DIR=%CUCKOO_CURRENT_DIR%%QEMU_NAME%\%QEMU_OS%\%QEMU_VERSION%
set QEMU_BIN_FILE=\%QEMU_NAME%-system-x86_64w.exe
set QEMU_TMP_DIR=%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%


rem ENV check
if "%QEMU_VERSION%" == "" (
    echo ERROR: QEMU version was not defined.
    echo Please check file '%CUCKOO_CURRENT_DIR%%QEMU_NAME%\%QEMU_OS%\VERSION'.
    exit 1
)
if not exist "%QEMU_RUN_DIR%\" (
    echo ERROR: Directory '%QEMU_RUN_DIR%' does not exist.
    exit 1
)
if not exist "%QEMU_RUN_DIR%%QEMU_BIN_FILE%" (
    echo ERROR: File '%QEMU_RUN_DIR%%QEMU_BIN_FILE%' does not exist.
    exit 1
)

rem Copy in TMP_DIR
"%QEMU_RUN_DIR%%QEMU_BIN_FILE%" -version > nul
if %ERRORLEVEL% neq 0 (
    mkdir "%QEMU_TMP_DIR%" > nul

    if exist "%QEMU_TMP_DIR%\" (
        xcopy /E /C /I /R /Y "%QEMU_RUN_DIR%" "%QEMU_TMP_DIR%"

        if exist "%QEMU_TMP_DIR%%QEMU_BIN_FILE%" (
            set QEMU_RUN_DIR=%QEMU_TMP_DIR%
        ) else (
            echo File '%QEMU_TMP_DIR%%QEMU_BIN_FILE%' does not exist.
            exit 1
        )
    ) else (
        echo ERROR: Directory '%QEMU_TMP_DIR%' does not exist.
        exit 1
    )
)

rem QEMU run
start /MAX %QEMU_RUN_DIR%%QEMU_BIN_FILE% ^
    -name " Cuckoo [%CUCKOO_OS_BIT%] -- %CUCKOO_OS% on %QEMU_OS% " ^
    -boot order=c ^
    -drive media=disk,if=scsi,index=0,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\0 ^
    -drive media=disk,if=scsi,index=1,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\1 ^
    -drive media=disk,if=scsi,index=2,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\2 ^
    -drive media=disk,if=scsi,index=3,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\3 ^
    -m 1G ^
    -cpu "%QEMU_NAME%%CUCKOO_OS_BIT%" -smp %CUCKOO_CPU_CORES%,cores=%CUCKOO_CPU_CORES%,maxcpus=%CUCKOO_CPU_CORES% ^
    -vga std ^
    -sdl -display sdl ^
    -usb -usbdevice tablet
