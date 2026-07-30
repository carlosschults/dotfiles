@echo off
echo.
cd /d %OneDrive%\work
if /I %0 EQU "%~dpnx0" (explorer .)
