@echo off
setlocal
:: Always run from the folder where this file lives.
cd /d "%~dp0"

:: Self-elevate if we're not already Administrator. The Office Deployment
:: Tool needs admin rights to write to Program Files.
net session >nul 2>&1
if %errorlevel% neq 0 (
    echo Requesting administrator privileges...
    powershell -NoProfile -Command "try { Start-Process -FilePath '%~f0' -Verb RunAs } catch { Write-Host 'Elevation cancelled.' -ForegroundColor Red; exit 1 }"
    exit /b
)

:: Clear the Mark-of-the-Web that ZIP downloads add (this is what makes
:: PowerShell complain that the script "is not digitally signed").
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Unblock-File -LiteralPath '%~dp0m365apps.ps1' -ErrorAction SilentlyContinue"

:: Launch the PowerShell installer with Bypass so it runs unsigned.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0m365apps.ps1"

endlocal
