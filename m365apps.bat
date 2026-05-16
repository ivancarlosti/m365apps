@echo off
setlocal
:: Always run from the folder where this file lives.
cd /d "%~dp0"

:: Clear the Mark-of-the-Web that ZIP downloads add (this is what makes
:: PowerShell complain that the script "is not digitally signed").
powershell -NoProfile -ExecutionPolicy Bypass -Command ^
    "Unblock-File -LiteralPath '%~dp0m365apps.ps1' -ErrorAction SilentlyContinue"

:: Launch the PowerShell installer with Bypass so it runs unsigned.
:: setup.exe will trigger its own UAC prompt when it needs admin rights.
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0m365apps.ps1"

endlocal
