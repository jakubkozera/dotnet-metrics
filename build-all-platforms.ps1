# Build script for DotNetMetrics - Self-contained deployment for multiple platforms
param(
    [string]$Configuration = "Release"
)

Write-Host "Building DotNetMetrics for multiple platforms..." -ForegroundColor Green
Write-Host "Configuration: $Configuration" -ForegroundColor Yellow
Write-Host ""

$projectPath = "DotNetMetrics.Console"
$outputBase = "builds"

# Create builds directory
if (Test-Path $outputBase) {
    Remove-Item $outputBase -Recurse -Force
}
New-Item -ItemType Directory -Path $outputBase | Out-Null

# Define target platforms
$platforms = @(
    @{ Name = "Windows x64"; RID = "win-x64"; Ext = ".exe" },
    @{ Name = "Windows x86"; RID = "win-x86"; Ext = ".exe" },
    @{ Name = "Windows ARM64"; RID = "win-arm64"; Ext = ".exe" },
    @{ Name = "Linux x64"; RID = "linux-x64"; Ext = "" },
    @{ Name = "Linux ARM64"; RID = "linux-arm64"; Ext = "" },
    @{ Name = "macOS x64"; RID = "osx-x64"; Ext = "" },
    @{ Name = "macOS ARM64"; RID = "osx-arm64"; Ext = "" }
)

foreach ($platform in $platforms) {
    Write-Host "Building for $($platform.Name) ($($platform.RID))..." -ForegroundColor Cyan
    
    $outputPath = Join-Path $outputBase $platform.RID
    
    try {
        dotnet publish $projectPath `
            --configuration $Configuration `
            --runtime $platform.RID `
            --self-contained true `
            --output $outputPath `
            --verbosity quiet `
            -p:IsPublishing=true
        
        if ($LASTEXITCODE -eq 0) {
            $exeName = "DotNetMetrics.Console$($platform.Ext)"
            $exePath = Join-Path $outputPath $exeName
            
            if (Test-Path $exePath) {
                $fileSize = [math]::Round((Get-Item $exePath).Length / 1MB, 2)
                Write-Host "  [SUCCESS] File: $exeName ($fileSize MB)" -ForegroundColor Green
            } else {
                Write-Host "  [WARNING] Built successfully, but executable not found" -ForegroundColor Yellow
            }
        } else {
            Write-Host "  [FAILED] Failed to build for $($platform.Name)" -ForegroundColor Red
        }
    }
    catch {
        Write-Host "  [ERROR] Error building for $($platform.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
    
    Write-Host ""
}

Write-Host "Build completed! Check the 'builds' folder for executables." -ForegroundColor Green
Write-Host ""
Write-Host "Usage examples:" -ForegroundColor Yellow
Write-Host "  Windows: .\builds\win-x64\DotNetMetrics.Console.exe 1234" -ForegroundColor Cyan
Write-Host "  Linux:   ./builds/linux-x64/DotNetMetrics.Console 1234" -ForegroundColor Cyan
Write-Host "  macOS:   ./builds/osx-x64/DotNetMetrics.Console 1234" -ForegroundColor Cyan