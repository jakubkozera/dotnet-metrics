# DotNetMetrics - Publishing Guide

## How to Publish as Global Tool

### 1. Update Package Information

Edit `DotNetMetrics.Console.csproj`:
```xml
<PackageId>DotNetMetrics.Tool</PackageId>
<Version>1.0.0</Version>  <!-- Update version for each release -->
<Authors>Your Name</Authors>
<Description>Real-time monitoring tool for .NET Core process metrics</Description>
<PackageProjectUrl>https://github.com/yourusername/dotnetmetrics</PackageProjectUrl>
<RepositoryUrl>https://github.com/yourusername/dotnetmetrics</RepositoryUrl>
```

### 2. Build and Test Locally

```powershell
# Pack the tool
.\pack-tool.ps1

# Install locally for testing
.\pack-tool.ps1 -LocalInstall

# Test the tool
dotnet-metrics
dotnet metrics 1234
```

### 3. Publish to NuGet.org

#### Prerequisites
- NuGet.org account
- API key from https://www.nuget.org/account/apikeys

#### Publishing Steps
```powershell
# Method 1: Using script
.\pack-tool.ps1 -PublishToNuGet -NuGetApiKey "YOUR_API_KEY"

# Method 2: Manual
dotnet pack DotNetMetrics.Console --configuration Release --output nupkg
dotnet nuget push nupkg/DotNetMetrics.Tool.1.0.0.nupkg --api-key YOUR_API_KEY --source https://api.nuget.org/v3/index.json
```

### 4. Users Can Install

After publishing to NuGet:
```bash
# Global installation
dotnet tool install -g DotNetMetrics.Tool

# Usage
dotnet-metrics 1234
dotnet metrics 1234
```

## Package Details

- **Package ID**: `DotNetMetrics.Tool`
- **Command Names**: `dotnet-metrics`, `dotnet metrics`
- **Size**: ~400 KB
- **Dependencies**: .NET 8.0 runtime required
- **Platforms**: Windows, Linux, macOS

## Version Management

### Update Version
1. Increment version in `.csproj`
2. Pack and publish new version
3. Users update with: `dotnet tool update -g DotNetMetrics.Tool`

### Version Strategy
- **Major (1.x.x)**: Breaking changes
- **Minor (x.1.x)**: New features
- **Patch (x.x.1)**: Bug fixes

## Distribution Options

### Option 1: NuGet.org (Public)
- Free hosting
- Global discovery
- Automatic updates

### Option 2: Private NuGet Feed
- Company/organization only
- More control over distribution
- Can require authentication

### Option 3: GitHub Packages
- Integrated with GitHub
- Private or public packages
- CI/CD integration

## Example CI/CD Pipeline

### GitHub Actions
```yaml
name: Publish Tool
on:
  release:
    types: [published]

jobs:
  publish:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - name: Setup .NET
      uses: actions/setup-dotnet@v3
      with:
        dotnet-version: 8.0.x
        
    - name: Pack
      run: dotnet pack DotNetMetrics.Console --configuration Release --output nupkg
      
    - name: Publish to NuGet
      run: dotnet nuget push nupkg/*.nupkg --api-key ${{ secrets.NUGET_API_KEY }} --source https://api.nuget.org/v3/index.json
```

## Marketing & Documentation

### NuGet Package Page
- Clear description
- Usage examples
- Links to documentation
- Tags for discoverability

### README.md
- Installation instructions
- Usage examples
- Feature highlights
- Troubleshooting

### Documentation
- GLOBAL-TOOL.md - User guide
- BUILD.md - Developer guide
- Examples and tutorials

## Success Metrics

Track package usage:
- Download count on NuGet
- GitHub stars/forks
- Issues and feedback
- Community contributions