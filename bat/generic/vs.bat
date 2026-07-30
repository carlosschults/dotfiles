@echo off
setlocal
for /r %%f in (*.sln *.slnx) do (
    start "" "%%f"
    goto :end
)
echo No .sln or .slnx file found in the current directory or subdirectories.
exit /b 1
:end
endlocal