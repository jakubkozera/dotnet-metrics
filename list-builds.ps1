# List all built executables with details
param()

Write-Host "DotNetMetrics - Built Executables" -ForegroundColor Green
Write-Host "=================================" -ForegroundColor Green
Write-Host ""

if (-not (Test-Path "builds")) {
    Write-Host "No builds directory found. Run build scripts first." -ForegroundColor Red
    exit 1
}

$executables = Get-ChildItem builds -Recurse | Where-Object { 
    $_.Name -like "*DotNetMetrics.Console*" -and $_.Extension -ne ".pdb" 
}

if ($executables.Count -eq 0) {
    Write-Host "No executables found in builds directory." -ForegroundColor Yellow
    exit 1
}

foreach ($exe in $executables) {
    $platform = Split-Path (Split-Path $exe.FullName -Parent) -Leaf
    $size = [math]::Round($exe.Length / 1MB, 2)
    $relativePath = $exe.FullName.Replace((Get-Location).Path, ".")
    
    Write-Host "Platform: $platform" -ForegroundColor Cyan
    Write-Host "  File: $($exe.Name)" -ForegroundColor White
    Write-Host "  Size: $size MB" -ForegroundColor Yellow
    Write-Host "  Path: $relativePath" -ForegroundColor Gray
    
    # Show usage example
    if ($platform.StartsWith("win")) {
        Write-Host "  Usage: $relativePath 1234" -ForegroundColor Green
    } else {
        Write-Host "  Usage: $($relativePath.Replace('\','/')) 1234" -ForegroundColor Green
    }
    Write-Host ""
}

Write-Host "Total platforms built: $($executables.Count)" -ForegroundColor Magenta
Write-Host ""
Write-Host "Quick test commands:" -ForegroundColor Yellow
Write-Host "  Get-Process | Select-Object -First 1 | ForEach-Object { .\builds\win-x64\DotNetMetrics.Console.exe `$_.Id }" -ForegroundColor Gray