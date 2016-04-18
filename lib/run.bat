@echo off

if "%CUCKOO_OS%" == "" set CUCKOO_OS=linux
if "%CUCKOO_ARCH%" == "" set CUCKOO_ARCH=x86_64
if "%CUCKOO_DIST_VERSION%" == "" (
    set CUCKOO_DIST_VERSION=%CUCKOO_ISO_FILE%
)
if "%CUCKOO_DIST_VERSION%" == "" (
    set CUCKOO_DIST_VERSION_DIR=
) else (
    set CUCKOO_DIST_VERSION_DIR=%CUCKOO_DIST_VERSION%\
)
if not "%CUCKOO_ISO_FILE%" == "" (
    set CUCKOO_ISO_FILE=%CUCKOO_ISO_FILE%.iso
)
if "%CUCKOO_CPU_CORES%" == "" set CUCKOO_CPU_CORES=4
if "%CUCKOO_CPU_THREADS%" == "" set CUCKOO_CPU_THREADS=2
if "%CUCKOO_CPU_SOCKETS%" == "" set CUCKOO_CPU_SOCKETS=1
if "%CUCKOO_TMP_DIR%" == "" (
    set CUCKOO_TMP_DIR=%TEMP%\
) else (
    set CUCKOO_TMP_DIR=%CUCKOO_TMP_DIR%\
)
if "%1" == "" (
    @echo ERROR: Current directory has not been defined
    @pause
    @exit 1
) else (
    set CUCKOO_CURRENT_DIR=%1
)
if "%CUCKOO_ARCH%" == "x86_64" (
    set CUCKOO_OS_BIT=64
) else (
    set CUCKOO_OS_BIT=32
)
set CUCKOO_ISO_DIR=%CUCKOO_CURRENT_DIR%..\..\..\install\iso\%CUCKOO_ARCH%\%CUCKOO_OS%\

set QEMU_NAME=qemu
set QEMU_OS=windows
if "%QEMU_ARCH%" == "" set QEMU_ARCH=x86_64
if "%QEMU_HD%" == "" set QEMU_HD=virtio
if "%QEMU_CDROM_FILE%" == "" set QEMU_CDROM_FILE=
if "%QEMU_SMB_DIR%" == "" set QEMU_SMB_DIR=
if "%QEMU_NO_USB%" == "" set QEMU_NO_USB=
if "%QEMU_NO_DAEMONIZE%" == "" (
    set QEMU_NO_DAEMONIZE=w
) else (
    set QEMU_NO_DAEMONIZE=
)

if "%QEMU_MEMORY_SIZE%" == "" set QEMU_MEMORY_SIZE=1G
set /P QEMU_VERSION=<%CUCKOO_CURRENT_DIR%..\bin\%QEMU_OS%\VERSION
set QEMU_BIN_DIR=%CUCKOO_CURRENT_DIR%..\bin\%QEMU_OS%\%QEMU_VERSION%\
set QEMU_TMP_DIR=%CUCKOO_TMP_DIR%\%QEMU_NAME%\%QEMU_VERSION%\
set QEMU_HD_DIR=%CUCKOO_CURRENT_DIR%..\hd\%CUCKOO_OS%\%CUCKOO_DIST_VERSION_DIR%
set QEMU_BIN_FILE=%QEMU_NAME%-system-%QEMU_ARCH%%QEMU_NO_DAEMONIZE%.exe
if "%QEMU_OPTS%" == "" set QEMU_OPTS=


rem  ENV check

if "%QEMU_VERSION%" == "" (
    @echo ERROR: QEMU version was not defined.
    @echo Please check file '%CUCKOO_CURRENT_DIR%..\bin\%QEMU_OS%\VERSION'
    @pause
    @exit 1
)
if not exist "%QEMU_BIN_DIR%" (
    @echo ERROR: Directory '%QEMU_BIN_DIR%' does not exist
    @pause
    @exit 1
)
if not exist "%QEMU_BIN_DIR%%QEMU_BIN_FILE%" (
    @echo ERROR: File '%QEMU_BIN_DIR%%QEMU_BIN_FILE%' does not exist
    @pause
    @exit 1
)


rem  Copy in TMP_DIR

"%QEMU_BIN_DIR%%QEMU_BIN_FILE%" -version > nul
if %ERRORLEVEL% neq 0 (
    mkdir "%QEMU_TMP_DIR%" > nul

    if exist "%QEMU_TMP_DIR%" (
        xcopy /E /C /I /R /Y "%QEMU_BIN_DIR%" "%QEMU_TMP_DIR%"

        if exist "%QEMU_TMP_DIR%%QEMU_BIN_FILE%" (
            set QEMU_BIN_DIR=%QEMU_TMP_DIR%
        ) else (
            @echo File '%QEMU_TMP_DIR%%QEMU_BIN_FILE%' does not exist
            @pause
            @exit 1
        )
    ) else (
        @echo ERROR: Directory '%QEMU_TMP_DIR%' does not exist
        @pause
        @exit 1
    )
)


rem  QEMU run

rem Bootloading and CDROM
set QEMU_OPTS=%QEMU_OPTS% -boot order=
if "%QEMU_CDROM_FILE%" == "" (
    if "%CUCKOO_ISO_FILE%" == "" set QEMU_OPTS=%QEMU_OPTS%c
)
if not "%QEMU_CDROM_FILE%" == "" (
    set QEMU_OPTS=%QEMU_OPTS%d -cdrom %QEMU_CDROM_FILE%
)
if not "%CUCKOO_ISO_FILE%" == "" (
    set QEMU_OPTS=%QEMU_OPTS%d -cdrom %CUCKOO_ISO_DIR%%CUCKOO_ISO_FILE%
)

rem Memory
rem set QEMU_OPTS=%QEMU_OPTS% -m %QEMU_MEMORY_SIZE% -balloon virtio

rem CPU
set /A cpus=%CUCKOO_CPU_CORES%*%CUCKOO_CPU_THREADS%*%CUCKOO_CPU_SOCKETS%
set QEMU_OPTS=%QEMU_OPTS% -cpu %QEMU_NAME%%CUCKOO_OS_BIT% -smp cpus=%cpus%,cores=%CUCKOO_CPU_CORES%,threads=%CUCKOO_CPU_THREADS%,sockets=%CUCKOO_CPU_SOCKETS%

rem Drive
setlocal EnableDelayedExpansion
for /F "usebackq" %%f in (`dir /A-D /O /B "%QEMU_HD_DIR%"`) do (
   set QEMU_OPTS=!QEMU_OPTS! -drive media=disk,if=%QEMU_HD%,index=%%f,file=%QEMU_HD_DIR%%%f
)

rem Screen
set QEMU_OPTS=%QEMU_OPTS% -vga std -sdl -display sdl

rem USB
if "%QEMU_NO_USB%" == "" (
    set QEMU_OPTS=%QEMU_OPTS% -usb -usbdevice tablet
)

rem SMB directory
if not "%QEMU_SMB_DIR%" == "" (
    set QEMU_OPTS=%QEMU_OPTS% -net nic -net user,smb=%QEMU_SMB_DIR%
)

start /MAX %QEMU_BIN_DIR%%QEMU_BIN_FILE% -name " Cuckoo [%CUCKOO_ARCH%] -- %CUCKOO_OS% on %QEMU_OS% " %QEMU_OPTS%
