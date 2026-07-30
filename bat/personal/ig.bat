@echo off
echo.
cd /d %OneDrive%\Igreja
if /I %0 EQU "%~dpnx0" (explorer .)
