# DotNetMetrics Global Tool

## Installation

### From NuGet (Recommended)
```bash
dotnet tool install -g DotNetMetrics.Tool
```

### From Local Package
```bash
# After building the package
dotnet tool install -g DotNetMetrics.Tool --add-source ./nupkg
```

## Usage

### Command Options
```bash
# Primary command
dotnet-metrics <PID>

# Alternative command  
dotnet metrics <PID>
```

### Examples
```bash
# Monitor process with PID 1234
dotnet-metrics 1234

# Monitor using dotnet command
dotnet metrics 1234

# Show help
dotnet-metrics
```

## Finding Process PID

### Windows (PowerShell)
```powershell
# Find all .NET processes
Get-Process | Where-Object {$_.ProcessName -like "*dotnet*"}

# Find specific application
Get-Process | Where-Object {$_.ProcessName -like "*myapp*"}

# Show PID, name, and memory
Get-Process | Select-Object Id, ProcessName, WorkingSet | Format-Table
```

### Linux/macOS
```bash
# Find all processes
ps aux | grep dotnet

# Find specific application  
ps aux | grep myapp

# Show tree view
pstree -p
```

## Example Output

```json
{
  "timestamp": "2025-08-24T19:15:32.1234567Z",
  "processId": 1234,
  "processName": "myapp",
  "cpuUsagePercent": 15.67,
  "memoryUsageMB": 256.78,
  "workingSetMB": 189.45,
  "privateMemoryMB": 167.89
}
```

## Features

- ✅ **Real-time monitoring** - Updates every second
- ✅ **JSON output** - Machine-readable format
- ✅ **Cross-platform** - Windows, Linux, macOS
- ✅ **Global tool** - Available from anywhere
- ✅ **No dependencies** - Requires only .NET runtime
- ✅ **Clear console** - Shows only current metrics

## Management

### Update Tool
```bash
dotnet tool update -g DotNetMetrics.Tool
```

### Uninstall Tool
```bash
dotnet tool uninstall -g DotNetMetrics.Tool
```

### List Installed Tools
```bash
dotnet tool list -g
```

## Building from Source

### Prerequisites
- .NET 8.0 SDK

### Build Steps
```bash
# Clone repository
git clone <repository-url>
cd DotNetMetrics

# Pack as tool
dotnet pack DotNetMetrics.Console --configuration Release --output nupkg

# Install locally
dotnet tool install -g DotNetMetrics.Tool --add-source nupkg
```

### Publishing to NuGet

1. Update version in `DotNetMetrics.Console.csproj`
2. Build package:
   ```bash
   dotnet pack DotNetMetrics.Console --configuration Release --output nupkg
   ```
3. Publish to NuGet:
   ```bash
   dotnet nuget push nupkg/DotNetMetrics.Tool.*.nupkg --api-key YOUR_API_KEY --source https://api.nuget.org/v3/index.json
   ```

## Troubleshooting

### Tool Not Found
```bash
# Refresh PATH
$env:PATH = [System.Environment]::GetEnvironmentVariable("PATH","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("PATH","User")

# Or restart terminal
```

### Permission Denied
- Windows: Run as Administrator
- Linux/macOS: Use `sudo` if needed

### Process Not Found
```bash
# Verify process exists
Get-Process -Id 1234

# Or on Linux/macOS
ps -p 1234
```

## Integration

### Use in Scripts
```powershell
# PowerShell
$metrics = dotnet-metrics 1234 | ConvertFrom-Json
Write-Host "CPU: $($metrics.cpuUsagePercent)%"
```

```bash
# Bash
metrics=$(dotnet-metrics 1234)
echo "Memory: $(echo $metrics | jq .memoryUsageMB) MB"
```

### CI/CD Monitoring
```yaml
# GitHub Actions example
- name: Monitor Application
  run: |
    dotnet-metrics ${{ env.APP_PID }} > metrics.json
    # Process metrics.json
```