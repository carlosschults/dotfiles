@echo off
echo.
cd /d %src%
if /I %0 EQU "%~dpnx0" (explorer .)
