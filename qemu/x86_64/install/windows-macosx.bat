@echo off
@cls

set CUCKOO_OS=macosx
if "%CUCKOO_ISO_FILE%" == "" set CUCKOO_ISO_FILE=10.11

@call "%~dp0..\..\..\lib\hd.bat" %~dp0
@call "%~dp0..\run\%~nx0"
