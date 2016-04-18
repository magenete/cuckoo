@echo off
@cls

if "%CUCKOO_DIST_VERSION%" == "" set CUCKOO_DIST_VERSION=debian-8.4

@call "%~dp0..\..\..\lib\run.bat" %~dp0
