# Build script for Windows x64
param(
    [string]$Configuration = "Release"
)

Write-Host "Building DotNetMetrics for Windows x64..." -ForegroundColor Green
Write-Host ""

$outputPath = "builds\win-x64"

if (Test-Path "builds") {
    if (Test-Path $outputPath) {
        Remove-Item $outputPath -Recurse -Force
    }
} else {
    New-Item -ItemType Directory -Path "builds" | Out-Null
}

try {
    dotnet publish DotNetMetrics.Console `
        --configuration $Configuration `
        --runtime win-x64 `
        --self-contained true `
        --output $outputPath `
        -p:IsPublishing=true

    if ($LASTEXITCODE -eq 0) {
        $exePath = Join-Path $outputPath "DotNetMetrics.Console.exe"
        if (Test-Path $exePath) {
            $fileSize = [math]::Round((Get-Item $exePath).Length / 1MB, 2)
            Write-Host ""
            Write-Host "Build successful!" -ForegroundColor Green
            Write-Host "Executable: $exePath ($fileSize MB)" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "Usage: $exePath [PID]" -ForegroundColor Yellow
            Write-Host "Example: $exePath 1234" -ForegroundColor Yellow
        }
    } else {
        Write-Host "Build failed!" -ForegroundColor Red
    }
}
catch {
    Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
}