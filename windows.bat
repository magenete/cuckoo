@echo off

systeminfo | find "System type:" | findstr /i 64 > nul
if %errorlevel%==0 (
    $CUCKOO_OS_BIT=64
) else (
    $CUCKOO_OS_BIT=32
)


