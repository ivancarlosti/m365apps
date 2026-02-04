@echo off
setlocal enabledelayedexpansion
:: Force the script to run from the folder where it is saved
cd /d "%~dp0"
:: Set console encoding to UTF-8
chcp 65001 >nul
cls

:begin
echo ============================================================
echo                MICROSOFT OFFICE INSTALLER
echo ============================================================
echo.
echo 1 - Install Office Business + Project + Visio
echo 2 - Install Office Business (US+BR+MX)
echo 3 - Install Office Business (Brazil Only)
echo 4 - Install Office Enterprise + Project + Visio
echo 5 - Install Office Enterprise (US+BR+MX)
echo 6 - Install Office Enterprise (Brazil Only)
echo 7 - Install Office Home + Project + Visio
echo 8 - Install Office Home (US+BR+MX)
echo 9 - Install Office Home (Brazil Only)
echo 0 - Uninstall All Office Packages
echo.
echo ============================================================

:: Use CHOICE command for better reliability on Windows 11
echo Please press the number of your choice...
choice /c 1234567890 /n /m "Selection: "

:: Errorlevel 1 corresponds to "1", errorlevel 10 corresponds to "0"
set op=%errorlevel%

if %op%==1 goto op1
if %op%==2 goto op2
if %op%==3 goto op3
if %op%==4 goto op4
if %op%==5 goto op5
if %op%==6 goto op6
if %op%==7 goto op7
if %op%==8 goto op8
if %op%==9 goto op9
if %op%==10 goto op0

:op1
echo Installing Office Business + Project + Visio, please wait...
setup.exe /configure "XMLFiles/InstallOfficeProjectVisio-Business.xml"
goto end

:op2
echo Installing Office Business (US+BR+MX), please wait...
setup.exe /configure "XMLFiles/InstallOffice-Business-US.xml"
goto end

:op3
echo Installing Office Business (Brazil), please wait...
setup.exe /configure "XMLFiles/InstallOffice-Business-BR.xml"
goto end

:op4
echo Installing Office Enterprise + Project + Visio, please wait...
setup.exe /configure "XMLFiles/InstallOfficeProjectVisio-Enterprise.xml"
goto end

:op5
echo Installing Office Enterprise (US+BR+MX), please wait...
setup.exe /configure "XMLFiles/InstallOffice-Enterprise-US.xml"
goto end

:op6
echo Installing Office Enterprise (Brazil), please wait...
setup.exe /configure "XMLFiles/InstallOffice-Enterprise-BR.xml"
goto end

:op7
echo Installing Office Home + Project + Visio, please wait...
setup.exe /configure "XMLFiles/InstallOfficeProjectVisio-Home.xml"
goto end

:op8
echo Installing Office Home (US+BR+MX), please wait...
setup.exe /configure "XMLFiles/InstallOffice-Home-US.xml"
goto end

:op9
echo Installing Office Home (Brazil), please wait...
setup.exe /configure "XMLFiles/InstallOffice-Home-BR.xml"
goto end

:op0
echo Uninstalling Office, please wait...
setup.exe /configure "XMLFiles/UninstallOffice.xml"
goto end

:end
echo.
echo ============================================================
echo Process finished. Please check if the Office Setup started.
pause
exit