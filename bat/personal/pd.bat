@echo off
echo.
cd /d %src%\projects\project-david
if /I %0 EQU "%~dpnx0" (explorer .)