# DotNet Metrics Tool

[![NuGet Version](https://img.shields.io/nuget/v/DotNetMetrics.Tool)](https://www.nuget.org/packages/DotNetMetrics.Tool)
[![NuGet Downloads](https://img.shields.io/nuget/dt/DotNetMetrics.Tool)](https://www.nuget.org/packages/DotNetMetrics.Tool)
[![Build](https://github.com/jakubkozera/dotnet-metrics/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/jakubkozera/dotnet-metrics/actions/workflows/build-and-publish.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Real-time monitoring tool for .NET Core process metrics. Monitor any .NET process by PID and get JSON output with CPU usage, memory consumption, and performance metrics.

## Features

- 🔍 **Real-time monitoring** - Updates every second
- 📊 **Comprehensive metrics** - CPU usage, memory consumption, working set, private memory
- 📝 **JSON output** - Structured data perfect for logging and analysis
- 💾 **File output** - Save metrics to file for continuous monitoring
- 🚀 **Cross-platform** - Works on Windows, Linux, and macOS
- ⚡ **Lightweight** - Minimal overhead on system resources
- 🛠️ **Easy installation** - Install as a global .NET tool

## Installation

Install as a global .NET tool:

```bash
dotnet tool install --global DotNetMetrics.Tool
```

## Usage

### Basic monitoring (console output)

```bash
dotnet-metrics <PID>
```

### Save to file (silent mode)

```bash
dotnet-metrics <PID> --out metrics.json
dotnet-metrics <PID> -o /path/to/metrics.json
```

### Find process PID

**Windows (PowerShell):**
```powershell
Get-Process | Where-Object {$_.ProcessName -like '*your-app*'}
```

**Linux/macOS:**
```bash
ps aux | grep your-app
```

### Alternative (Command Prompt)

```cmd
tasklist | findstr "process_name"
```

### Task Manager

1. Open Task Manager (Ctrl+Shift+Esc)
2. Go to "Details" tab
3. Find your process and check the "PID" column

## Example Output

```json
{
  "timestamp": "2025-08-25T10:30:45.123Z",
  "processId": 1234,
  "processName": "MyApp",
  "cpuUsagePercent": 15.67,
  "memoryUsageMB": 256.78,
  "workingSetMB": 312.45,
  "privateMemoryMB": 189.23
}
```

## Metrics Explained

- **timestamp** - ISO 8601 timestamp of the measurement
- **processId** - Process ID being monitored
- **processName** - Name of the process
- **cpuUsagePercent** - CPU usage as percentage (0-100)
- **memoryUsageMB** - Paged memory usage in megabytes
- **workingSetMB** - Physical memory usage in megabytes
- **privateMemoryMB** - Private memory usage in megabytes

## Use Cases

- **Performance monitoring** - Track application resource usage
- **CI/CD pipelines** - Monitor test execution performance
- **Production monitoring** - Continuous performance tracking
- **Debugging** - Identify memory leaks and CPU spikes
- **Load testing** - Monitor application behavior under load

## Parameters

| Parameter | Short | Description |
|-----------|-------|-------------|
| `<PID>` | - | Process ID to monitor (required) |
| `--out` | `-o` | Output file path (optional) |

## Usage Examples

### Option 1: Direct via .NET CLI

```bash
cd DotNetMetrics.Console
dotnet run <PID>
```

### Option 2: Using helper scripts

#### Windows Command Prompt

```cmd
monitor_process.bat <PID>
```

#### PowerShell

```powershell
.\monitor_process.ps1 -ProcessId <PID>
```

### Example Commands

```bash
dotnet run 1234
# or
monitor_process.bat 1234
# or
.\monitor_process.ps1 -ProcessId 1234
```

Where `1234` is the PID of the .NET Core process you want to monitor.

## Stopping Monitoring

Press `Ctrl+C` to stop monitoring.

## Self-contained Builds

Pre-built self-contained executables are available for all major platforms:

| Platform | Executable | Size | 
|----------|------------|------|
| Windows x64 | `builds/win-x64/DotNetMetrics.Console.exe` | ~12 MB |
| Windows x86 | `builds/win-x86/DotNetMetrics.Console.exe` | ~11 MB |
| Windows ARM64 | `builds/win-arm64/DotNetMetrics.Console.exe` | ~12 MB |
| Linux x64 | `builds/linux-x64/DotNetMetrics.Console` | ~13 MB |
| Linux ARM64 | `builds/linux-arm64/DotNetMetrics.Console` | ~13 MB |
| macOS x64 | `builds/osx-x64/DotNetMetrics.Console` | ~13 MB |
| macOS ARM64 | `builds/osx-arm64/DotNetMetrics.Console` | ~13 MB |

### Building Self-Contained Executables

#### Build for Current Platform (Windows)
```powershell
.\build-windows.ps1
```

#### Build for All Platforms
```powershell
.\build-all-platforms.ps1
```

#### List Built Executables
```powershell
.\list-builds.ps1
```

See [BUILD.md](BUILD.md) for detailed build instructions.

## Requirements

- .NET 8.0 or higher
- Appropriate permissions to read process information

## Building from Source

```bash
git clone https://github.com/jakubkozera/dotnet-metrics.git
cd dotnet-metrics
dotnet pack DotNetMetrics.Console --configuration Release
dotnet tool install --global --add-source ./nupkg DotNetMetrics.Tool
```

## Troubleshooting

### "Process with PID X not found"

- Check if the process actually exists
- Verify the PID is correct

### "Cannot access process"

- Run the application as administrator
- Check if the process is still running

### High CPU usage in first measurement

- The first CPU measurement may be imprecise
- The application performs baseline measurement before starting actual monitoring

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Author

**Jakub Kozera**
- GitHub: [@jakubkozera](https://github.com/jakubkozera)

---

⭐ If this tool helps you, please consider giving it a star!
