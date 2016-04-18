@echo off
@cls

set CUCKOO_OS=netbsd
if "%CUCKOO_ISO_FILE%" == "" set CUCKOO_ISO_FILE=7.0

@call "%~dp0..\..\..\lib\hd.bat" %~dp0
@call "%~dp0..\run\%~nx0"
