#Requires -Version 5.1

Write-Host "🎨 Silhouette - Oh My Posh Setup for Windows" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host ""

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$ThemeFile = Join-Path $ScriptDir "silhouette.omp.json"

# Check if theme file exists
if (-not (Test-Path $ThemeFile)) {
    Write-Host "❌ Error: Theme file not found at $ThemeFile" -ForegroundColor Red
    exit 1
}

# Check if oh-my-posh is installed
$OhMyPoshInstalled = Get-Command oh-my-posh -ErrorAction SilentlyContinue

if (-not $OhMyPoshInstalled) {
    Write-Host "📦 Installing oh-my-posh..." -ForegroundColor Yellow

    # Try to install via winget
    $WingetInstalled = Get-Command winget -ErrorAction SilentlyContinue

    if ($WingetInstalled) {
        Write-Host "   Using winget..." -ForegroundColor Gray
        winget install JanDeDobbeleer.OhMyPosh -s winget

        # Refresh environment variables
        $env:Path = [System.Environment]::GetEnvironmentVariable("Path","Machine") + ";" + [System.Environment]::GetEnvironmentVariable("Path","User")

        Write-Host "✅ Oh-my-posh installed successfully!" -ForegroundColor Green
    } else {
        Write-Host "❌ winget not found. Please install oh-my-posh manually:" -ForegroundColor Red
        Write-Host "   winget install JanDeDobbeleer.OhMyPosh -s winget" -ForegroundColor Yellow
        Write-Host "   or visit: https://ohmyposh.dev/docs/installation/windows" -ForegroundColor Yellow
        exit 1
    }
} else {
    Write-Host "✅ Oh-my-posh is already installed" -ForegroundColor Green
}

# Create oh-my-posh config directory
$ConfigDir = Join-Path $env:USERPROFILE ".config\ohmyposh"
if (-not (Test-Path $ConfigDir)) {
    New-Item -ItemType Directory -Path $ConfigDir -Force | Out-Null
}

# Copy theme file
Write-Host "📋 Copying theme file..." -ForegroundColor Yellow
$DestTheme = Join-Path $ConfigDir "silhouette.omp.json"
Copy-Item $ThemeFile $DestTheme -Force
Write-Host "✅ Theme file copied to $DestTheme" -ForegroundColor Green

# Setup PowerShell profile
Write-Host ""
Write-Host "🐚 Setting up PowerShell profile..." -ForegroundColor Yellow

# Check if profile exists, create if not
if (-not (Test-Path $PROFILE)) {
    New-Item -ItemType File -Path $PROFILE -Force | Out-Null
    Write-Host "   Created PowerShell profile at $PROFILE" -ForegroundColor Gray
}

# Read current profile content
$ProfileContent = Get-Content $PROFILE -Raw -ErrorAction SilentlyContinue

# Check if oh-my-posh is already configured
if ($ProfileContent -notmatch "oh-my-posh init pwsh") {
    # Add oh-my-posh initialization
    $OmpInit = @"

# Oh My Posh initialization (added by Silhouette)
oh-my-posh init pwsh --config "$($DestTheme -replace '\\', '\\')" | Invoke-Expression
"@

    Add-Content -Path $PROFILE -Value $OmpInit
    Write-Host "✅ Added oh-my-posh to PowerShell profile" -ForegroundColor Green
} else {
    Write-Host "ℹ️  Oh-my-posh already configured in PowerShell profile" -ForegroundColor Cyan
}

Write-Host ""
Write-Host "🎉 Setup complete!" -ForegroundColor Green
Write-Host ""
Write-Host "📝 Next steps:" -ForegroundColor Yellow
Write-Host "   1. Install a Nerd Font for proper icon display:" -ForegroundColor White
Write-Host "      oh-my-posh font install" -ForegroundColor Gray
Write-Host "      (Recommended: MesloLGM NF)" -ForegroundColor Gray
Write-Host ""
Write-Host "   2. Configure Windows Terminal to use the Nerd Font:" -ForegroundColor White
Write-Host "      Settings → Defaults → Appearance → Font face" -ForegroundColor Gray
Write-Host ""
Write-Host "   3. Restart your PowerShell session or run:" -ForegroundColor White
Write-Host "      . `$PROFILE" -ForegroundColor Gray
Write-Host ""
