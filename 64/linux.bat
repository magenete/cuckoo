@echo off

set CUCKOO_OS_BIT=64
set CUCKOO_CPU_CORES=4
set CUCKOO_CURRENT_DIR=%~dp0
set CUCKOO_TMP_DIR=%TEMP%

set QEMU_VERSION=2.5.0
set QEMU_DIR=qemu
set QEMU_RUN_DIR=%CUCKOO_CURRENT_DIR%%QEMU_DIR%\windows\%QEMU_VERSION%
set QEMU_BIN_FILE=\qemu-system-x86_64


"%QEMU_RUN_DIR%%QEMU_BIN_FILE%" -version > nul
if %ERRORLEVEL% == 0 (
    mkdir "%CUCKOO_TMP_DIR%\%QEMU_DIR%\%QEMU_VERSION%" > nul
    xcopy /E /C /I /R /Y  "%QEMU_RUN_DIR%" "%CUCKOO_TMP_DIR%\%QEMU_DIR%\%QEMU_VERSION%"
    set QEMU_RUN_DIR=%CUCKOO_TMP_DIR%\%QEMU_DIR%\%QEMU_VERSION%
)

echo "%QEMU_RUN_DIR%%QEMU_BIN_FILE%" ^
    -name "Cuckoo -- Windows [%CUCKOO_OS_BIT%]" ^
    -boot=c ^
    -drive media=disk,index=0,file=%CUCKOO_CURRENT_DIR%hd\0 ^
    -drive media=disk,index=1,file=%CUCKOO_CURRENT_DIR%hd\1 ^
    -drive media=disk,index=2,file=%CUCKOO_CURRENT_DIR%hd\2 ^
    -drive media=disk,index=3,file=%CUCKOO_CURRENT_DIR%hd\3 ^
    -drive media=disk,index=4,file=%CUCKOO_CURRENT_DIR%hd\4 ^
    -m 1G ^
    -cpu "%QEMU_DIR%%CUCKOO_OS_BIT%" -smp %CUCKOO_CPU_CORES%,cores=%CUCKOO_CPU_CORES%,maxcpus=%CUCKOO_CPU_CORES% ^
    -usb -usbdevice tablet > C:\Users\user\AppData\Local\Temp\qemu\q.txt
echo %ERRORLEVEL%
pause