@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


set CUCKOO_OS=windows
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=10\en


call "%~dp0..\..\..\lib\run.bat" %~dp0
