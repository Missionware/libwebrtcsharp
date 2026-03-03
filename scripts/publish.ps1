# Publish script for Missionware.LibWebrtcSharp.Android
# This script publishes the NuGet package to NuGet.org

param(
    [Parameter(Mandatory = $true)]
    [string]$ApiKey,
    
    [string]$ArtifactsPath = $null,
    [string]$Source = "https://api.nuget.org/v3/index.json",
    [switch]$SkipDuplicate = $true,
    [switch]$DryRun = $false
)

$ErrorActionPreference = "Stop"

# Get script directory and resolve to repo root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir

# Set default artifacts path if not provided
if ([string]::IsNullOrEmpty($ArtifactsPath)) {
    $ArtifactsPath = Join-Path -Path $repoRoot -ChildPath "artifacts"
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Publishing NuGet Package" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "! DRY RUN MODE - No package will be published" -ForegroundColor Yellow
    Write-Host ""
}

# Verify artifacts exist
if (-not (Test-Path $ArtifactsPath)) {
    Write-Host "? ERROR: Artifacts directory not found: $ArtifactsPath" -ForegroundColor Red
    exit 1
}

# Find NuGet package
$package = Get-ChildItem -Path (Join-Path -Path $ArtifactsPath -ChildPath "*.nupkg") -ErrorAction SilentlyContinue | Select-Object -First 1
if (-not $package) {
    Write-Host "? ERROR: No .nupkg file found in $ArtifactsPath" -ForegroundColor Red
    Write-Host ""
    Write-Host "Run build and pack first:" -ForegroundColor Yellow
    Write-Host "  ./scripts/build-and-pack.ps1" -ForegroundColor Cyan
    exit 1
}

Write-Host "Package to publish:" -ForegroundColor Yellow
$sizeMB = [math]::Round($package.Length / 1MB, 2)
Write-Host "  Name: $($package.Name)"
Write-Host "  Size: $sizeMB MB"
Write-Host "  Path: $($package.FullName)"
Write-Host ""

# Verify .NET CLI is available
Write-Host "Verifying .NET CLI..." -ForegroundColor Yellow
try {
    $dotnetVersion = dotnet --version
    Write-Host "? .NET version: $dotnetVersion"
} catch {
    Write-Host "? ERROR: .NET CLI not found!" -ForegroundColor Red
    exit 1
}
Write-Host ""

if ($DryRun) {
    Write-Host "DRY RUN: Would execute:" -ForegroundColor Yellow
    Write-Host "  dotnet nuget push `"$($package.FullName)`" \" 
    Write-Host "    --api-key [REDACTED] \"
    Write-Host "    --source `"$Source`" \"
    if ($SkipDuplicate) {
        Write-Host "    --skip-duplicate"
    }
    Write-Host ""
    Write-Host "Skipping actual publish in dry-run mode" -ForegroundColor Yellow
} else {
    # Validate API key is not empty
    if ([string]::IsNullOrWhiteSpace($ApiKey)) {
        Write-Host "? ERROR: API key cannot be empty" -ForegroundColor Red
        Write-Host ""
        Write-Host "Usage: ./scripts/publish.ps1 -ApiKey `"<your-api-key>`"" -ForegroundColor Yellow
        exit 1
    }

    Write-Host "Publishing package..." -ForegroundColor Yellow
    
    $args = @(
        "nuget", "push", $package.FullName,
        "--api-key", $ApiKey,
        "--source", $Source
    )
    
    if ($SkipDuplicate) {
        $args += "--skip-duplicate"
    }
    
    & dotnet @args
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "? ERROR: Failed to publish package" -ForegroundColor Red
        Write-Host ""
        Write-Host "Troubleshooting:" -ForegroundColor Yellow
        Write-Host "  - Verify your NuGet API key is valid"
        Write-Host "  - Check your internet connection"
        Write-Host "  - Try dry-run mode first: ./scripts/publish.ps1 -ApiKey `$env:NUGET_API_KEY -DryRun"
        exit 1
    }
    Write-Host "? Package published successfully"
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Publish completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
