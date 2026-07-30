@echo off
echo.
notepad++ %* 2>nul || notepad %*
