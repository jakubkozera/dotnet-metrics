# Script to pack and publish DotNetMetrics as a global .NET tool
param(
    [string]$Configuration = "Release",
    [string]$OutputPath = "nupkg",
    [switch]$LocalInstall,
    [switch]$PublishToNuGet,
    [string]$NuGetApiKey = ""
)

Write-Host "DotNetMetrics - Global Tool Packaging" -ForegroundColor Green
Write-Host "====================================" -ForegroundColor Green
Write-Host ""

$projectPath = "DotNetMetrics.Console"

# Clean and create output directory
if (Test-Path $OutputPath) {
    Remove-Item $OutputPath -Recurse -Force
}
New-Item -ItemType Directory -Path $OutputPath | Out-Null

try {
    # Pack as tool
    Write-Host "Packing as global tool..." -ForegroundColor Cyan
    dotnet pack $projectPath `
        --configuration $Configuration `
        --output $OutputPath `
        --verbosity normal

    if ($LASTEXITCODE -ne 0) {
        throw "Pack failed"
    }

    # Get the package file
    $packageFile = Get-ChildItem $OutputPath -Filter "*.nupkg" | Select-Object -First 1
    if (-not $packageFile) {
        throw "Package file not found"
    }

    Write-Host ""
    Write-Host "[SUCCESS] Package created: $($packageFile.FullName)" -ForegroundColor Green
    Write-Host "Package size: $([math]::Round($packageFile.Length / 1KB, 2)) KB" -ForegroundColor Yellow
    Write-Host ""

    # Local installation
    if ($LocalInstall) {
        Write-Host "Installing tool locally..." -ForegroundColor Cyan
        
        # Uninstall if already exists
        dotnet tool uninstall -g DotNetMetrics.Tool 2>$null
        
        # Install from local package
        dotnet tool install -g DotNetMetrics.Tool --add-source $OutputPath
        
        if ($LASTEXITCODE -eq 0) {
            Write-Host "[SUCCESS] Tool installed globally!" -ForegroundColor Green
            Write-Host ""
            Write-Host "Usage examples:" -ForegroundColor Yellow
            Write-Host "  dotnet-metrics 1234" -ForegroundColor Cyan
            Write-Host "  dotnet metrics 1234" -ForegroundColor Cyan
            Write-Host ""
            Write-Host "To uninstall:" -ForegroundColor Yellow
            Write-Host "  dotnet tool uninstall -g DotNetMetrics.Tool" -ForegroundColor Gray
        } else {
            Write-Host "[FAILED] Tool installation failed" -ForegroundColor Red
        }
    }

    # Publish to NuGet
    if ($PublishToNuGet) {
        if ([string]::IsNullOrEmpty($NuGetApiKey)) {
            Write-Host "[WARNING] NuGet API key not provided. Use -NuGetApiKey parameter." -ForegroundColor Yellow
        } else {
            Write-Host "Publishing to NuGet.org..." -ForegroundColor Cyan
            dotnet nuget push $packageFile.FullName --api-key $NuGetApiKey --source https://api.nuget.org/v3/index.json
            
            if ($LASTEXITCODE -eq 0) {
                Write-Host "[SUCCESS] Package published to NuGet!" -ForegroundColor Green
                Write-Host ""
                Write-Host "Users can now install with:" -ForegroundColor Yellow
                Write-Host "  dotnet tool install -g DotNetMetrics.Tool" -ForegroundColor Cyan
            } else {
                Write-Host "[FAILED] NuGet publish failed" -ForegroundColor Red
            }
        }
    }

    Write-Host ""
    Write-Host "Manual installation commands:" -ForegroundColor Yellow
    Write-Host "  # Install from local package" -ForegroundColor Gray
    Write-Host "  dotnet tool install -g DotNetMetrics.Tool --add-source $OutputPath" -ForegroundColor Cyan
    Write-Host ""
    Write-Host "  # Install from NuGet (after publishing)" -ForegroundColor Gray
    Write-Host "  dotnet tool install -g DotNetMetrics.Tool" -ForegroundColor Cyan

}
catch {
    Write-Host "[ERROR] $($_.Exception.Message)" -ForegroundColor Red
    exit 1
}