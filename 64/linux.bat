@echo off

set CUCKOO_OS=linux
set CUCKOO_OS_BIT=64
set CUCKOO_CPU_CORES=4
set CUCKOO_CURRENT_DIR=%~dp0
set CUCKOO_TMP_DIR=%TEMP%

set QEMU_NAME=qemu
set /P QEMU_VERSION=<%CUCKOO_CURRENT_DIR%%QEMU_NAME%\windows\VERSION
set QEMU_RUN_DIR=%CUCKOO_CURRENT_DIR%%QEMU_NAME%\windows\%QEMU_VERSION%
set QEMU_BIN_FILE=\%QEMU_NAME%-system-x86_64w.exe


"%QEMU_RUN_DIR%%QEMU_BIN_FILE%" -version > nul
if %ERRORLEVEL% neq 0 (
    mkdir "%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%" > nul
    xcopy /E /C /I /R /Y "%QEMU_RUN_DIR%" "%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%"
    set QEMU_RUN_DIR=%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%
)

start /MAX %QEMU_RUN_DIR%%QEMU_BIN_FILE% ^
    -name " Cuckoo -- Linux [%CUCKOO_OS_BIT%] " ^
    -boot order=c ^
    -drive if=scsi,index=0,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\0 ^
    -drive if=scsi,index=1,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\1 ^
    -drive if=scsi,index=2,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\2 ^
    -drive if=scsi,index=3,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\3 ^
    -m 1G ^
    -cpu "%QEMU_NAME%%CUCKOO_OS_BIT%" -smp %CUCKOO_CPU_CORES%,cores=%CUCKOO_CPU_CORES%,maxcpus=%CUCKOO_CPU_CORES% ^
    -vga std ^
    -sdl -display sdl ^
    -machine mem-merge=off ^
    -usb -usbdevice tablet
