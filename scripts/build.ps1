# Build script for Missionware.LibWebrtcSharp.Android
# This script mirrors the GitHub Actions build workflow

param(
    [string]$Configuration = "Release",
    [switch]$Clean = $false,
    [switch]$Verbose = $false,
    [switch]$SkipJavaCheck = $false
)

$ErrorActionPreference = "Stop"
$VerbosePreference = if ($Verbose) { "Continue" } else { "SilentlyContinue" }

# Get script directory and resolve to repo root
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir

# Configuration
$DOTNET_VERSION = "9.0.x"
$PROJECT_PATH = Join-Path -Path $repoRoot -ChildPath "Missionware.LibWebrtcSharp.Android\Missionware.LibWebrtcSharp.Android.csproj"
$ANDROID_SDK_VERSION = "34"

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Building Missionware.LibWebrtcSharp.Android" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""

# Verify .NET is installed
Write-Host "Verifying .NET installation..." -ForegroundColor Yellow
try {
    $dotnetPath = dotnet --version
    Write-Host "? .NET version: $dotnetPath"
} catch {
    Write-Host "? ERROR: .NET CLI not found!" -ForegroundColor Red
    Write-Host "Install .NET 9.x from https://dotnet.microsoft.com/download" -ForegroundColor Yellow
    exit 1
}

# Verify Java is installed (unless skipped)
if (-not $SkipJavaCheck) {
    Write-Host "Verifying Java installation..." -ForegroundColor Yellow
    $javaFound = $false
    try {
        # java -version outputs to stderr, so we redirect both stdout and stderr
        $javaOutput = & java -version 2>&1
        if ($LASTEXITCODE -eq 0 -or $javaOutput -like "*version*") {
            Write-Host "? Java installed"
            $javaFound = $true
        }
    } catch {
        # Continue to check if JAVA_HOME is set
    }
    
    if (-not $javaFound -and -not $env:JAVA_HOME) {
        Write-Host "? ERROR: Java is required but not found!" -ForegroundColor Red
        Write-Host ""
        Write-Host "Setup options:" -ForegroundColor Yellow
        Write-Host "  1. Install Java 17+:"
        Write-Host "     - https://www.java.com (OpenJDK)"
        Write-Host "     - https://adoptium.net (Eclipse Temurin)"
        Write-Host "     - https://www.microsoft.com/openjdk (Microsoft OpenJDK)"
        Write-Host ""
        Write-Host "  2. Set JAVA_HOME environment variable:"
        Write-Host "     `$env:JAVA_HOME = 'C:\Program Files\Java\jdk-17'"
        Write-Host ""
        Write-Host "  3. Or skip this check:"
        Write-Host "     ./scripts/build.ps1 -SkipJavaCheck"
        Write-Host ""
        exit 1
    }
}

# Display environment info
Write-Host ""
Write-Host "Build environment:" -ForegroundColor Yellow
if ($env:ANDROID_HOME) {
    Write-Host "  ANDROID_HOME: $env:ANDROID_HOME"
} else {
    Write-Host "  ANDROID_HOME: [Not Set]" -ForegroundColor Yellow
}
if ($env:ANDROID_SDK_ROOT) {
    Write-Host "  ANDROID_SDK_ROOT: $env:ANDROID_SDK_ROOT"
} else {
    Write-Host "  ANDROID_SDK_ROOT: [Not Set]" -ForegroundColor Yellow
}
if ($env:JAVA_HOME) {
    Write-Host "  JAVA_HOME: $env:JAVA_HOME"
} else {
    Write-Host "  JAVA_HOME: [Not Set]" -ForegroundColor Yellow
}
Write-Host "  Configuration: $Configuration"

# Verify Android SDK is accessible
if (-not $env:ANDROID_HOME -and -not $env:ANDROID_SDK_ROOT) {
    Write-Host ""
    Write-Host "? WARNING: Android SDK paths not set" -ForegroundColor Yellow
    Write-Host "The build may fail if Android SDK is not installed or accessible" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "To set Android SDK path:" -ForegroundColor Yellow
    Write-Host "  `$env:ANDROID_HOME = 'C:\Android\sdk'" -ForegroundColor Cyan
    Write-Host ""
}

# Clean build artifacts if requested
if ($Clean) {
    Write-Host ""
    Write-Host "Cleaning build artifacts..." -ForegroundColor Yellow
    $cleanPaths = @(
        (Join-Path -Path $repoRoot -ChildPath "Missionware.LibWebrtcSharp.Android\obj"),
        (Join-Path -Path $repoRoot -ChildPath "Missionware.LibWebrtcSharp.Android\bin")
    )
    
    foreach ($path in $cleanPaths) {
        if (Test-Path $path) {
            Write-Host "  Removing $path"
            Remove-Item -Recurse -Force $path
        }
    }
}

# Restore dependencies
Write-Host ""
Write-Host "Restoring dependencies..." -ForegroundColor Yellow
& dotnet restore $PROJECT_PATH -v $(if ($Verbose) { "detailed" } else { "minimal" })
if ($LASTEXITCODE -ne 0) {
    Write-Host "? ERROR: Failed to restore dependencies" -ForegroundColor Red
    exit 1
}
Write-Host "? Dependencies restored"

# Build project
Write-Host ""
Write-Host "Building project..." -ForegroundColor Yellow
& dotnet build $PROJECT_PATH `
    --configuration $Configuration `
    --no-restore `
    -p:AndroidSdkDirectory="$env:ANDROID_HOME" `
    -p:JavaSdkDirectory="$env:JAVA_HOME" `
    -v $(if ($Verbose) { "detailed" } else { "minimal" }) `
    -bl:build.binlog

if ($LASTEXITCODE -ne 0) {
    Write-Host "? ERROR: Build failed" -ForegroundColor Red
    Write-Host ""
    Write-Host "Build log saved to: build.binlog" -ForegroundColor Yellow
    Write-Host "For details, see: Missionware.LibWebrtcSharp.Android/obj/" -ForegroundColor Yellow
    exit 1
}

Write-Host "? Build completed"

Write-Host ""
Write-Host "========================================" -ForegroundColor Green
Write-Host "Build completed successfully!" -ForegroundColor Green
Write-Host "========================================" -ForegroundColor Green
