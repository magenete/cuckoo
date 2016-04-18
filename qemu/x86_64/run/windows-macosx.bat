@echo off
@cls

set CUCKOO_OS=macosx
if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=10.11

@call "%~dp0..\..\..\lib\run.bat" %~dp0
