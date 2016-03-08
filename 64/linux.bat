@echo off

set CUCKOO_OS=linux
set CUCKOO_OS_BIT=64
set CUCKOO_CPU_CORES=4
set CUCKOO_CURRENT_DIR=%~dp0
set CUCKOO_TMP_DIR=%TEMP%

set QEMU_NAME=qemu
set QEMU_VERSION=2.5.0
set QEMU_RUN_DIR=%CUCKOO_CURRENT_DIR%%QEMU_NAME%\%CUCKOO_OS%\%QEMU_VERSION%
set QEMU_BIN_FILE=\%QEMU_NAME%-system-x86_64.exe


rem "%QEMU_RUN_DIR%%QEMU_BIN_FILE%" -version > nul
rem if %ERRORLEVEL% == 0 (
    mkdir "%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%" > nul
    xcopy /E /C /I /R /Y "%QEMU_RUN_DIR%" "%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%"
    set QEMU_RUN_DIR=%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%
rem )

cd "%QEMU_RUN_DIR%"
"%QEMU_RUN_DIR%%QEMU_BIN_FILE%" ^
    -L %QEMU_RUN_DIR% ^
    -name " Cuckoo -- Linux [%CUCKOO_OS_BIT%] " ^
    -boot order=c ^
    -drive media=disk,index=0,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\0 ^
    -drive media=disk,index=1,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\1 ^
    -drive media=disk,index=2,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\2 ^
    -drive media=disk,index=3,file=%CUCKOO_CURRENT_DIR%hd\%CUCKOO_OS%\3 ^
    -m 1G ^
    -sdl -display sdl ^
    -cpu "%QEMU_NAME%%CUCKOO_OS_BIT%" -smp %CUCKOO_CPU_CORES%,cores=%CUCKOO_CPU_CORES%,maxcpus=%CUCKOO_CPU_CORES% ^
    -usb -usbdevice tablet
