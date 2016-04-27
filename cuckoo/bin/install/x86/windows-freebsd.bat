@echo off
rem 
rem A desktop-oriented virtual machines management system written in Shell.
rem 
rem Code is available online at https://github.com/magenete/cuckoo
rem See LICENSE for licensing information, and README for details.
rem 
rem Copyright (C) 2016 Magenete Systems OÜ
rem 


set CUCKOO_OS=freebsd
if "%CUCKOO_ISO_FILE%" == "" set CUCKOO_ISO_FILE=10.3


call "%~dp0..\..\..\lib\hd.bat" %~dp0
call "%~dp0..\run\%~nx0"
