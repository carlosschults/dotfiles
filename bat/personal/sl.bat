@echo off
echo.
cd /d %OneDrive%\Igreja\Slides
for /f "tokens=*" %%f in ('dir /b ^| findstr "^[0-9][0-9][0-9][0-9]"') do set lastLine=%%f
cd %lastLine%
if /I %0 EQU "%~dpnx0" (explorer .)
