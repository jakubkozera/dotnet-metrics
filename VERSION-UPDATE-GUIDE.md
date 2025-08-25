# Instrukcja aktualizacji wersji DotNetMetrics Tool

## Krok 1: Przygotowanie nowej wersji

### 1.1 Aktualizacja numeru wersji
Edytuj plik `DotNetMetrics.Console\DotNetMetrics.Console.csproj` i zmień numer wersji:

```xml
<Version>1.0.X</Version>  <!-- Zmień na nową wersję -->
```

### 1.2 Opcjonalnie - aktualizacja kodu
Jeśli wprowadzasz zmiany w kodzie, edytuj `DotNetMetrics.Console\Program.cs`

## Krok 2: Budowanie nowej wersji

### 2.1 Otwórz PowerShell w folderze głównym projektu
```powershell
cd c:\Users\Jakub\source\repos\vscode-extensions\DotNetMetrics
```

### 2.2 Zbuduj nowy pakiet
```powershell
dotnet pack DotNetMetrics.Console --configuration Release --output nupkg
```

### 2.3 Zaktualizuj lokalne narzędzie
```powershell
dotnet tool update --local --add-source ./nupkg DotNetMetrics.Tool
```

## Krok 3: Weryfikacja

### 3.1 Sprawdź wersję
```powershell
dotnet tool list --local
```

### 3.2 Przetestuj narzędzie
```powershell
# Znajdź PID procesu .NET
Get-Process | Where-Object {$_.ProcessName -like "*dotnet*"} | Select-Object Id, ProcessName

# Uruchom monitoring (zastąp XXXX rzeczywistym PID)
dotnet dotnet-metrics XXXX
```

## Krok 4: Opcjonalnie - Self-contained builds

Jeśli potrzebujesz self-contained builds dla różnych platform:

```powershell
# Windows x64
dotnet publish DotNetMetrics.Console -c Release -r win-x64 --self-contained true -o builds/win-x64

# Linux x64
dotnet publish DotNetMetrics.Console -c Release -r linux-x64 --self-contained true -o builds/linux-x64

# macOS x64
dotnet publish DotNetMetrics.Console -c Release -r osx-x64 --self-contained true -o builds/osx-x64

# macOS ARM64 (Apple Silicon)
dotnet publish DotNetMetrics.Console -c Release -r osx-arm64 --self-contained true -o builds/osx-arm64
```

## Automatyzacja procesu

Możesz też użyć gotowych skryptów:

### Pack-local-tool.ps1
```powershell
.\scripts\pack-local-tool.ps1
```
Ten skrypt automatycznie:
- Buduje pakiet
- Aktualizuje lokalne narzędzie
- Wyświetla informacje o wersji

### Build-all-platforms.ps1
```powershell
.\scripts\build-all-platforms.ps1
```
Ten skrypt buduje self-contained wersje dla wszystkich platform.

## Przykład kompletnej aktualizacji

```powershell
# 1. Przejdź do folderu projektu
cd c:\Users\Jakub\source\repos\vscode-extensions\DotNetMetrics

# 2. Zmień wersję w .csproj (ręcznie w edytorze)
# <Version>1.0.3</Version>

# 3. Zbuduj i zaktualizuj
dotnet pack DotNetMetrics.Console --configuration Release --output nupkg
dotnet tool update --local --add-source ./nupkg DotNetMetrics.Tool

# 4. Sprawdź
dotnet tool list --local

# 5. Przetestuj
dotnet dotnet-metrics [PID_PROCESU]
```

## Uwagi

- **Ostrzeżenia NuGet**: Ostrzeżenia o vulnerabilities w System.Text.Json są znane i nie wpływają na funkcjonalność narzędzia
- **Wersje**: Zawsze zwiększaj numer wersji przed budowaniem nowego pakietu
- **Lokalne vs Globalne**: Ta instrukcja dotyczy lokalnych narzędzi. Dla globalnych użyj `dotnet tool update -g`
- **Backup**: Przed większymi zmianami zrób kopię zapasową kodu