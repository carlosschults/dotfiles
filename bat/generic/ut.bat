@echo off
echo.
cd /d C:\utils
if /I %0 EQU "%~dpnx0" (explorer .)
