@echo off
setlocal

if "%1"=="" (
    echo Usage: monitor_process.bat ^<PID^>
    echo Example: monitor_process.bat 1234
    exit /b 1
)

echo Starting process monitoring for PID: %1
echo.

cd /d "%~dp0DotNetMetrics.Console"
dotnet run -- %1