@echo off
echo.
cd /d %OneDrive%\evernote
if /I %0 EQU "%~dpnx0" (explorer .)
