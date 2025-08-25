# Publikacja na NuGet - Instrukcje

## Wymagania wstępne

1. **Konto NuGet.org**
   - Załóż konto na https://www.nuget.org/
   - Zweryfikuj email

2. **API Key**
   - Idź do https://www.nuget.org/account/apikeys
   - Utwórz nowy API key z uprawnieniami "Push new packages and package versions"
   - Skopiuj klucz (będzie potrzebny tylko raz!)

## Publikacja manualna

### 1. Zbuduj pakiet
```bash
dotnet pack DotNetMetrics.Console --configuration Release --output ./nupkg
```

### 2. Opublikuj na NuGet
```bash
dotnet nuget push "./nupkg/*.nupkg" --api-key YOUR_API_KEY --source https://api.nuget.org/v3/index.json
```

Zastąp `YOUR_API_KEY` swoim kluczem API z NuGet.org.

## Publikacja automatyczna (GitHub Actions)

### 1. Dodaj secret do GitHub

1. Idź do repozytorium na GitHub
2. Settings > Secrets and variables > Actions
3. Kliknij "New repository secret"
4. Name: `NUGET_API_KEY`
5. Secret: Twój API key z NuGet.org
6. Kliknij "Add secret"

### 2. Automatyczne publikacje

GitHub Actions automatycznie:
- **Na push do main**: Publikuje nową wersję na NuGet
- **Na tagi v*.*.***: Tworzy release z plikami wykonywalnymi
- **Na pull request**: Tylko buduje (nie publikuje)

### 3. Tworzenie release

```bash
# Zwiększ wersję w .csproj
# Commit i push
git add .
git commit -m "Bump version to 1.0.9"
git push

# Utwórz tag dla release
git tag v1.0.9
git push origin v1.0.9
```

## Struktura wersjonowania

- **1.0.x** - Łatki (bug fixes)
- **1.x.0** - Nowe funkcje (backwards compatible)
- **x.0.0** - Breaking changes

## Sprawdzenie publikacji

1. **NuGet.org**: https://www.nuget.org/packages/DotNetMetrics.Tool
2. **Instalacja**: `dotnet tool install --global DotNetMetrics.Tool`
3. **Aktualizacja**: `dotnet tool update --global DotNetMetrics.Tool`

## Przydatne komendy

```bash
# Sprawdź zainstalowane wersje
dotnet tool list --global

# Odinstaluj tool
dotnet tool uninstall --global DotNetMetrics.Tool

# Zainstaluj konkretną wersję
dotnet tool install --global DotNetMetrics.Tool --version 1.0.8

# Sprawdź zawartość pakietu
dotnet nuget locals all --list
```

## Rozwiązywanie problemów

### "Package already exists"
- Zwiększ numer wersji w .csproj
- Nie można nadpisać istniejącej wersji na NuGet

### "Invalid API key"
- Sprawdź czy API key jest poprawny
- Sprawdź uprawnienia klucza na NuGet.org

### "Package validation failed"
- Sprawdź czy wszystkie wymagane metadane są w .csproj
- Sprawdź czy README.md istnieje

## Monitorowanie

- **Download stats**: https://www.nuget.org/stats/packages/DotNetMetrics.Tool
- **GitHub releases**: https://github.com/jakubkozera/dotnet-metrics/releases
- **GitHub Actions**: https://github.com/jakubkozera/dotnet-metrics/actions