@echo off
echo.
cd /d %OneDrive%
if /I %0 EQU "%~dpnx0" (explorer .)
