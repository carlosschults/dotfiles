@echo off
echo.
cd /d %UserProfile%
if /I %0 EQU "%~dpnx0" (explorer .)
