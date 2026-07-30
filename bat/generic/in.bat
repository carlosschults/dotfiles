@echo off
echo.
cd /d %OneDrive%\#inbox
if /I %0 EQU "%~dpnx0" (explorer .)
