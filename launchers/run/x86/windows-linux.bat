@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


set CUCKOO_ARCH=x86
set CUCKOO_CPU_CORES=2
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=debian-8.4


call "%~dp0..\..\..\lib\run.bat" %~dp0
