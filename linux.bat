@echo off

systeminfo | find "-based " | findstr /i "64" > nul
if %ERRORLEVEL% == 0 (
    set CUCKOO_OS_BIT=64
) else (
    set CUCKOO_OS_BIT=32
)


call "%~dp0%CUCKOO_OS_BIT%\%~nx0"
