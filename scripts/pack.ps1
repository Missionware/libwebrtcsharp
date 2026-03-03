# Pack script for Missionware.LibWebrtcSharp.Android
# This script creates a NuGet package

param(
    [string]$Configuration = "Release",
    [switch]$Verbose = $false
)

$ErrorActionPreference = "Stop"
$VerbosePreference = if ($Verbose) { "Continue" } else { "SilentlyContinue" }

# Get script directory and resolve to repo root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir

# Configuration
$PROJECT_PATH = Join-Path -Path $repoRoot -ChildPath "Missionware.LibWebrtcSharp.Android\Missionware.LibWebrtcSharp.Android.csproj"
$ARTIFACTS_PATH = Join-Path -Path $repoRoot -ChildPath "artifacts"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Packing NuGet Package" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Create artifacts directory if it doesn't exist
if (-not (Test-Path $ARTIFACTS_PATH)) {
    New-Item -ItemType Directory -Path $ARTIFACTS_PATH | Out-Null
    Write-Host "? Created artifacts directory: $ARTIFACTS_PATH"
}

# Verify project file exists
if (-not (Test-Path $PROJECT_PATH)) {
    Write-Host "? ERROR: Project file not found: $PROJECT_PATH" -ForegroundColor Red
    exit 1
}

# Pack NuGet package
Write-Host "Packing NuGet package..." -ForegroundColor Yellow
& dotnet pack $PROJECT_PATH `
    --configuration $Configuration `
    --no-build `
    --no-restore `
    --output $ARTIFACTS_PATH `
    -p:IncludeSymbols=false `
    -v $(if ($Verbose) { "detailed" } else { "minimal" })

if ($LASTEXITCODE -ne 0) {
    Write-Host "? ERROR: Failed to pack NuGet package" -ForegroundColor Red
    Write-Host ""
    Write-Host "Troubleshooting:" -ForegroundColor Yellow
    Write-Host "  - Ensure project file exists: $PROJECT_PATH"
    Write-Host "  - Build project first: ./scripts/build.ps1"
    Write-Host "  - Check build output for details"
    exit 1
}

# List package contents
Write-Host ""
Write-Host "Package artifacts:" -ForegroundColor Yellow
$artifacts = Get-ChildItem $ARTIFACTS_PATH -Recurse | Where-Object { -not $_.PSIsContainer }
if ($artifacts) {
    foreach ($artifact in $artifacts) {
        $sizeMB = [math]::Round($artifact.Length / 1MB, 2)
        Write-Host "  ? $($artifact.Name) - $sizeMB MB"
    }
} else {
    Write-Host "  No artifacts found" -ForegroundColor Yellow
}

# Get package info
$package = Get-ChildItem -Path (Join-Path -Path $ARTIFACTS_PATH -ChildPath "*.nupkg") -ErrorAction SilentlyContinue | Select-Object -First 1
if ($package) {
    $sizeMB = [math]::Round($package.Length / 1MB, 2)
    Write-Host ""
    Write-Host "Package Information:" -ForegroundColor Yellow
    Write-Host "  Name: $($package.Name)"
    Write-Host "  Size: $sizeMB MB"
    Write-Host "  Path: $($package.FullName)"
    
    # Validate package contents
    Write-Host ""
    Write-Host "Validating package contents..." -ForegroundColor Yellow
    
    try {
        Add-Type -AssemblyName System.IO.Compression.FileSystem -ErrorAction SilentlyContinue
        $zip = [System.IO.Compression.ZipFile]::OpenRead($package.FullName)
        
        $entryNames = $zip.Entries | ForEach-Object { $_.FullName }

        $hasManagedAssembly = $entryNames | Where-Object {
            $_ -like "lib/net9.0-android*/Missionware.LibWebrtcSharp.Android.dll" -or
            $_ -like "ref/net9.0-android*/Missionware.LibWebrtcSharp.Android.dll"
        }

        $hasLicenses = $entryNames | Where-Object { $_ -like "licenses/*" }

        $allFound = $true

        if ($hasManagedAssembly) {
            Write-Host "  ? Found: managed assembly (lib/ref net9.0-android*)"
        } else {
            Write-Host "  ? Missing: managed assembly in lib/ref net9.0-android*" -ForegroundColor Red
            $allFound = $false
        }

        if ($hasLicenses) {
            Write-Host "  ? Found: licenses/"
        } else {
            Write-Host "  ? Missing: licenses/" -ForegroundColor Red
            $allFound = $false
        }
        
        $zip.Dispose()
        
        if (-not $allFound) {
            Write-Host "? ERROR: Package validation failed" -ForegroundColor Red
            exit 1
        }
    } catch {
        Write-Host "? WARNING: Could not validate package contents: $($_.Exception.Message)" -ForegroundColor Yellow
    }
} else {
    Write-Host "? WARNING: No .nupkg file found in $ARTIFACTS_PATH" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Package created successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
