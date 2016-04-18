@echo off
@cls

if "%CUCKOO_ISO_FILE%" == "" set CUCKOO_ISO_FILE=debian\8.4

@call "%~dp0..\..\..\lib\hd.bat" %~dp0
@call "%~dp0..\run\%~nx0"
