@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


wmic os get osarchitecture | findstr /i "64" > nul
if %ERRORLEVEL% == 0 (
    set CUCKOO_ARCH=x86_64
) else (
    set CUCKOO_ARCH=x86
)

if "%3" == "--run" (
    set CUCKOO_ACTION=run
) else (
    if "%3" == "-r" set CUCKOO_ACTION=run
)
if "%3" == "--install" (
    set CUCKOO_ACTION=install
) else (
    if "%3" == "-i" (
        set CUCKOO_ACTION=install
    ) else (
        if not "%CUCKOO_ACTION%" == "run" set CUCKOO_ACTION=run
    )
)


if "%2" == "" (
    echo ERROR: Current system does not supported
    pause 
    exit 1
) else (
    set QEMU_OS=%2
)

if "%1" == "" (
    echo ERROR: Current directory has not been defined
    pause
    exit 1
) else (
    set CUCKOO_CURRENT_DIR=%1
)


call "%CUCKOO_CURRENT_DIR%%CUCKOO_ARCH%\%CUCKOO_ACTION%\windows-%QEMU_OS%"
