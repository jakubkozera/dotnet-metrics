param(
    [Parameter(Mandatory=$true)]
    [int]$ProcessId
)

Write-Host "Starting process monitoring for PID: $ProcessId" -ForegroundColor Green
Write-Host ""

$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path
$projectPath = Join-Path $scriptPath "DotNetMetrics.Console"

Set-Location $projectPath
dotnet run -- $ProcessId