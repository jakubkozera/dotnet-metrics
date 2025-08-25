@echo off
echo Building DotNetMetrics for Windows x64...
echo.

if not exist "builds" mkdir builds
if exist "builds\win-x64" rmdir /s /q "builds\win-x64"

dotnet publish DotNetMetrics.Console ^
    --configuration Release ^
    --runtime win-x64 ^
    --self-contained true ^
    --output builds\win-x64

if %ERRORLEVEL% EQU 0 (
    echo.
    echo ✓ Build successful!
    echo Executable: builds\win-x64\DotNetMetrics.Console.exe
    echo.
    echo Usage: builds\win-x64\DotNetMetrics.Console.exe ^<PID^>
) else (
    echo.
    echo ✗ Build failed!
)

pause