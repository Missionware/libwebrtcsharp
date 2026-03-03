# Full build and pack workflow for Missionware.LibWebrtcSharp.Android
# This script performs a complete build and creates a NuGet package

param(
    [string]$Configuration = "Release",
    [switch]$Clean = $false,
    [switch]$Verbose = $false,
    [switch]$SkipBuild = $false,
    [switch]$SkipJavaCheck = $false
)

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Full Build & Pack Workflow" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

# Run build script unless skipped
if (-not $SkipBuild) {
    Write-Host "Step 1: Building project..." -ForegroundColor Cyan
    & "$scriptPath\build.ps1" -Configuration $Configuration -Clean:$Clean -Verbose:$Verbose -SkipJavaCheck:$SkipJavaCheck
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "? ERROR: Build failed" -ForegroundColor Red
        exit 1
    }
    Write-Host ""
} else {
    Write-Host "Step 1: Skipped (using existing build)" -ForegroundColor Yellow
    Write-Host ""
}

# Run pack script
Write-Host "Step 2: Packing NuGet package..." -ForegroundColor Cyan
& "$scriptPath\pack.ps1" -Configuration $Configuration -Verbose:$Verbose

if ($LASTEXITCODE -ne 0) {
    Write-Host "? ERROR: Pack failed" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "Build & Pack workflow completed successfully!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "  - Review the package in .\artifacts\"
Write-Host "  - Run '.\scripts\publish.ps1 -ApiKey <your-api-key>' to publish"
Write-Host ""
