@ECHO OFF

REM systeminfo | findstr /i AMD64 > nul
REM wmic computersystem get systemtype
REM SYSTEMINFO |find "Total Physical Memory:"
REM IF /i "%_variable:_SearchString=%"=="%_variable%" (Echo String not found.) ELSE (Echo String found.)


REM systeminfo | find "System type:" | findstr /i 64 > nul
REM if %errorlevel%==0 (
REM     $CUCKOO_OS_BIT=64
REM ) else (
REM     $CUCKOO_OS_BIT=32
REM )

SET CUCKOO_OS_BIT=64
SET CUCKOO_CPU_CORES=4


G:\cuckoo\64\windows\qemu-2.5.0\qemu-system-x86_64w -name " Cuckoo -- Windows [%CUCKOO_OS_BIT%] " -boot order=c --drive media=disk,if=scsi,index=0,file=.\hd\0 --drive media=disk,if=scsi,index=1,file=.\hd\1 --drive media=disk,if=scsi,index=2,file=.\hd\2 --drive media=disk,if=scsi,index=3,file=.\hd\3 --drive media=disk,if=scsi,index=4,file=.\hd\4 -m 1G



rem    -cpu "qemu%CUCKOO_OS_BIT%" -smp %CUCKOO_CPU_CORES%,cores=%CUCKOO_CPU_CORES%,maxcpus=%CUCKOO_CPU_CORES% ^

rem    -vga std ^

rem    -usb -usbdevice tablet

