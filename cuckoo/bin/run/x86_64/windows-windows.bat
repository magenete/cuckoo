@echo off
@cls

set CUCKOO_OS=windows
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=10\en

@call "%~dp0..\..\..\lib\run.bat" %~dp0
