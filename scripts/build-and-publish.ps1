# Complete workflow: Build, Pack, and Publish
# This script performs a complete build, package creation, and publication workflow

param(
    [Parameter(Mandatory = $false)]
    [string]$ApiKey,
    
    [string]$Configuration = "Release",
    [switch]$Clean = $false,
    [switch]$DryRun = $false,
    [switch]$Verbose = $false,
    [switch]$SkipJavaCheck = $false
)

$ErrorActionPreference = "Stop"
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "================================================" -ForegroundColor Cyan
Write-Host "Complete Build, Pack & Publish Workflow" -ForegroundColor Cyan
Write-Host "================================================" -ForegroundColor Cyan
Write-Host ""

if ($DryRun) {
    Write-Host "! DRY RUN MODE - No publish will occur" -ForegroundColor Yellow
    Write-Host ""
}

# Step 1: Build and Pack
Write-Host "Step 1: Building and packing..." -ForegroundColor Cyan
& "$scriptPath\build-and-pack.ps1" -Configuration $Configuration -Clean:$Clean -Verbose:$Verbose -SkipJavaCheck:$SkipJavaCheck

if ($LASTEXITCODE -ne 0) {
    Write-Host "? ERROR: Build or pack failed" -ForegroundColor Red
    exit 1
}

# Step 2: Publish (if not dry-run)
if (-not $DryRun) {
    if (-not $ApiKey) {
        Write-Host ""
        Write-Host "? ERROR: ApiKey is required for publishing" -ForegroundColor Red
        Write-Host ""
        Write-Host "Usage: .\scripts\build-and-publish.ps1 -ApiKey <your-api-key>" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "Alternatively, set environment variable:" -ForegroundColor Yellow
        Write-Host "  `$env:NUGET_API_KEY = 'your-api-key'" -ForegroundColor Cyan
        Write-Host "  .\scripts\build-and-publish.ps1 -ApiKey `$env:NUGET_API_KEY" -ForegroundColor Cyan
        exit 1
    }
    
    Write-Host ""
    Write-Host "Step 2: Publishing to NuGet.org..." -ForegroundColor Cyan
    & "$scriptPath\publish.ps1" -ApiKey $ApiKey
    
    if ($LASTEXITCODE -ne 0) {
        Write-Host "? ERROR: Publish failed" -ForegroundColor Red
        exit 1
    }
} else {
    Write-Host ""
    Write-Host "Step 2: Skipped (dry-run mode)" -ForegroundColor Yellow
}

Write-Host ""
Write-Host "================================================" -ForegroundColor Green
Write-Host "Workflow completed successfully!" -ForegroundColor Green
Write-Host "================================================" -ForegroundColor Green
Write-Host ""
