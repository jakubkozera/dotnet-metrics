# DotNetMetrics - Build Instructions

This guide explains how to build DotNetMetrics as self-contained executables for different platforms.

## Prerequisites

- .NET 8.0 SDK or later
- PowerShell (for Windows scripts)

## Building Self-Contained Executables

### Option 1: Quick Build for Current Platform (Windows)

**Using PowerShell script:**
```powershell
.\build-windows.ps1
```

**Using Batch file:**
```cmd
build-windows.bat
```

**Manual command:**
```bash
dotnet publish DotNetMetrics.Console \
    --configuration Release \
    --runtime win-x64 \
    --self-contained true \
    --output builds\win-x64
```

### Option 2: Build for Multiple Platforms

**Using PowerShell script (recommended):**
```powershell
.\build-all-platforms.ps1
```

This will create executables for:
- Windows x64, x86, ARM64
- Linux x64, ARM64  
- macOS x64, ARM64

### Option 3: Manual Build for Specific Platform

```bash
# Windows x64
dotnet publish DotNetMetrics.Console --runtime win-x64 --self-contained true --output builds/win-x64

# Linux x64
dotnet publish DotNetMetrics.Console --runtime linux-x64 --self-contained true --output builds/linux-x64

# macOS x64
dotnet publish DotNetMetrics.Console --runtime osx-x64 --self-contained true --output builds/osx-x64

# macOS ARM64 (Apple Silicon)
dotnet publish DotNetMetrics.Console --runtime osx-arm64 --self-contained true --output builds/osx-arm64
```

## Output

Built executables will be located in the `builds/` directory:

```
builds/
├── win-x64/
│   └── DotNetMetrics.Console.exe (~12 MB)
├── linux-x64/
│   └── DotNetMetrics.Console (~12 MB)
├── osx-x64/
│   └── DotNetMetrics.Console (~12 MB)
└── osx-arm64/
    └── DotNetMetrics.Console (~12 MB)
```

## Usage Examples

### Windows
```cmd
.\builds\win-x64\DotNetMetrics.Console.exe 1234
```

### Linux
```bash
./builds/linux-x64/DotNetMetrics.Console 1234
```

### macOS
```bash
./builds/osx-x64/DotNetMetrics.Console 1234
```

## Features of Self-Contained Build

✅ **No .NET Runtime Required** - The executable includes the .NET runtime
✅ **Single File** - Everything bundled into one executable
✅ **Trimmed** - Unused code removed to reduce size
✅ **Cross-Platform** - Runs on Windows, Linux, and macOS
✅ **AOT Compatible** - Uses source generators for JSON serialization

## Platform-Specific Notes

### Windows
- Performance counters work on all Windows versions
- Requires appropriate permissions to read process information

### Linux
- Process monitoring works through /proc filesystem
- May require elevated permissions for some processes

### macOS
- Process monitoring works through system APIs
- May require permissions on newer macOS versions

## Troubleshooting

### "Permission denied" on Linux/macOS
```bash
chmod +x ./builds/linux-x64/DotNetMetrics.Console
```

### Large file size
The ~12MB size includes the entire .NET runtime. This is normal for self-contained deployments.

### Build failures
Ensure you have the latest .NET 8.0 SDK and all target platform workloads installed:
```bash
dotnet workload list
```

## Available Runtime Identifiers (RIDs)

Common RIDs you can use with `--runtime`:
- `win-x64`, `win-x86`, `win-arm64`
- `linux-x64`, `linux-arm64`, `linux-musl-x64`
- `osx-x64`, `osx-arm64`

For a complete list:
```bash
dotnet --info
```