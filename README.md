# DotNet Metrics Tool

[![NuGet Version](https://img.shields.io/nuget/v/DotNetMetrics.Tool)](https://www.nuget.org/packages/DotNetMetrics.Tool)
[![NuGet Downloads](https://img.shields.io/nuget/dt/DotNetMetrics.Tool)](https://www.nuget.org/packages/DotNetMetrics.Tool)
[![Build](https://github.com/jakubkozera/dotnet-metrics/actions/workflows/build-and-publish.yml/badge.svg)](https://github.com/jakubkozera/dotnet-metrics/actions/workflows/build-and-publish.yml)
[![License](https://img.shields.io/badge/license-MIT-blue.svg)](LICENSE)

Real-time monitoring tool for .NET Core process metrics. Monitor any .NET process by PID and get JSON output with CPU usage, memory consumption, and performance metrics.

## Features

- Process monitoring based on PID
- Real-time JSON metrics every second  
- Comprehensive metrics including:
  - CPU Usage (%)
  - Memory Usage (MB)
  - Working Set Memory (MB)
  - Private Memory (MB)
  - Timestamp and process information
- Self-contained executables for all major platforms
- No .NET Runtime installation required

## Requirements

- .NET 8.0 SDK (for building from source)
- OR use pre-built self-contained executables
- Appropriate permissions to read process information

## Quick Start

### Option 1: Use Pre-built Executables

1. Download the appropriate executable for your platform from the `builds/` folder
2. Run directly without any .NET installation:

```bash
# Windows
.\builds\win-x64\DotNetMetrics.Console.exe 1234

# Linux  
./builds/linux-x64/DotNetMetrics.Console 1234

# macOS
./builds/osx-x64/DotNetMetrics.Console 1234
```

### Option 2: Build from Source

```bash
# Clone and build
git clone <repository-url>
cd DotNetMetrics
dotnet restore DotNetMetrics.Console
dotnet build DotNetMetrics.Console

# Run from source
cd DotNetMetrics.Console
dotnet run -- <PID>
```

## Building Self-Contained Executables

### Build for Current Platform (Windows)
```powershell
.\build-windows.ps1
```

### Build for All Platforms  
```powershell
.\build-all-platforms.ps1
```

### List Built Executables
```powershell
.\list-builds.ps1
```

See [BUILD.md](BUILD.md) for detailed build instructions.

## Available Platforms

| Platform | Executable | Size | 
|----------|------------|------|
| Windows x64 | `builds/win-x64/DotNetMetrics.Console.exe` | ~12 MB |
| Windows x86 | `builds/win-x86/DotNetMetrics.Console.exe` | ~11 MB |
| Windows ARM64 | `builds/win-arm64/DotNetMetrics.Console.exe` | ~12 MB |
| Linux x64 | `builds/linux-x64/DotNetMetrics.Console` | ~13 MB |
| Linux ARM64 | `builds/linux-arm64/DotNetMetrics.Console` | ~13 MB |
| macOS x64 | `builds/osx-x64/DotNetMetrics.Console` | ~13 MB |
| macOS ARM64 | `builds/osx-arm64/DotNetMetrics.Console` | ~13 MB |

## Użytkowanie

### Opcja 1: Bezpośrednio przez .NET CLI

```bash
cd DotNetMetrics.Console
dotnet run <PID>
```

### Opcja 2: Używając skryptów pomocniczych

#### Windows Command Prompt

```cmd
monitor_process.bat <PID>
```

#### PowerShell

```powershell
.\monitor_process.ps1 -ProcessId <PID>
```

### Przykład

```bash
dotnet run 1234
# lub
monitor_process.bat 1234
# lub
.\monitor_process.ps1 -ProcessId 1234
```

Gdzie `1234` to PID procesu .NET Core, który chcesz monitorować.

### Przykładowe wyjście

```json
{
  "timestamp": "2025-08-24T10:30:15.123Z",
  "processId": 1234,
  "processName": "MyDotNetApp",
  "cpuUsagePercent": 15.67,
  "memoryUsageMB": 256.78,
  "workingSetMB": 189.45,
  "privateMemoryMB": 167.89
}
```

## Jak znaleźć PID procesu

### Windows (PowerShell)

```powershell
Get-Process | Where-Object {$_.ProcessName -like "*nazwa_procesu*"}
```

### Alternatywnie (Command Prompt)

```cmd
tasklist | findstr "nazwa_procesu"
```

### Task Manager

1. Otwórz Task Manager (Ctrl+Shift+Esc)
2. Przejdź do zakładki "Details"
3. Znajdź swój proces i sprawdź kolumnę "PID"

## Zatrzymywanie monitorowania

Naciśnij `Ctrl+C` aby zakończyć monitorowanie.

## Struktura danych JSON

| Pole | Typ | Opis |
|------|-----|------|
| `timestamp` | DateTime | Czas pomiaru w UTC |
| `processId` | int | ID procesu |
| `processName` | string | Nazwa procesu |
| `cpuUsagePercent` | double | Użycie CPU w procentach |
| `memoryUsageMB` | double | Pamięć stronicowana w MB |
| `workingSetMB` | double | Working Set w MB |
| `privateMemoryMB` | double | Pamięć prywatna w MB |

## Rozwiązywanie problemów

### "Proces o PID X nie został znaleziony"

- Sprawdź czy proces rzeczywiście istnieje
- Sprawdź czy PID jest poprawny

### "Nie można uzyskać dostępu do procesu"

- Uruchom aplikację jako administrator
- Sprawdź czy proces nadal działa

### Wysokie użycie CPU w pierwszym pomiarze

- Pierwszy pomiar CPU może być nieprecyzyjny
- Aplikacja wykonuje pomiar bazowy przed rozpoczęciem właściwego monitorowania

## Licencja

MIT License
