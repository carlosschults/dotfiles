@echo off
echo. 
cd /d %UserProfile%\Downloads
if /I %0 EQU "%~dpnx0" (explorer .)
