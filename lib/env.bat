@echo off
@cls

wmic os get osarchitecture | findstr /i "64" > nul
if %ERRORLEVEL% == 0 (
    set CUCKOO_OS_BIT=64
) else (
    set CUCKOO_OS_BIT=32
)

@call "%1%CUCKOO_OS_BIT%\windows-%2"
