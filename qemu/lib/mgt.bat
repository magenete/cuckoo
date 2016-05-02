@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


set QEMU_ACTION=
set QEMU_ACTION_DEFAULT=run
set QEMU_ACTION_ARCH_LIST=
set QEMU_ACTION_OS_LIST=
if "%QEMU_DIR%" == "" (
    set QEMU_DIR=%CUCKOO_DIR%..\qemu\
) else (
    set QEMU_DIR=%QEMU_DIR%\
)
set QEMU_OS_LIST=linux macosx windows
set QEMU_OS=
set QEMU_ARCH_LIST=x86 x86_64
set QEMU_ARCH=
