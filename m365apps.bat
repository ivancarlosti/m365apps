@echo off
chcp 65001 >nul

:: Elevate to Administrator
Set "Variable=0" & if exist "%temp%\getadmin.vbs" del "%temp%\getadmin.vbs"
fsutil dirty query %systemdrive% >nul 2>&1 && goto :Privileges_got
if "%1"=="%Variable%" (
  echo.
  echo Please right-click this file and select "Run as administrator".
  echo Press any key to exit.
  pause >nul 2>&1
  exit
)
cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~0", "%Variable%", "", "runas", 1 > "%temp%\getadmin.vbs"
cscript //nologo "%temp%\getadmin.vbs"
exit

:Privileges_got
setlocal EnableExtensions EnableDelayedExpansion
cd /d "%~dp0"

:: Download the latest Office Deployment Tool to a temporary folder
set "SETUP_URL=https://officecdn.microsoft.com/pr/wsus/setup.exe"
set "SETUP_DIR=%temp%\m365apps"
set "SETUP_EXE=%SETUP_DIR%\setup.exe"

if not exist "%SETUP_DIR%" mkdir "%SETUP_DIR%" >nul 2>&1
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1

echo Downloading the latest Office Deployment Tool from Microsoft...
curl.exe -fSL -o "%SETUP_EXE%" "%SETUP_URL%"
if not exist "%SETUP_EXE%" (
    echo.
    echo ERROR: Failed to download setup.exe from Microsoft.
    echo Please check your internet connection and try again.
    pause
    exit /b 1
)
echo Download complete.
echo.

:begin
echo ============================================================
echo                MICROSOFT OFFICE INSTALLER
echo ============================================================
echo.
echo 1 - Install Office Business + Project + Visio (US+BR+MX)
echo 2 - Install Office Business (US+BR+MX)
echo 3 - Install Office Business (Brazil Only)
echo 4 - Install Office Enterprise + Project + Visio (US+BR+MX)
echo 5 - Install Office Enterprise (US+BR+MX)
echo 6 - Install Office Enterprise (Brazil Only)
echo 7 - Install Office Home + Project + Visio (US+BR+MX)
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

if %op%==1  (set "DESC=Office Business + Project + Visio (US+BR+MX)"   & set "XML=XMLFiles/InstallOfficeProjectVisio-Business.xml"   & goto run)
if %op%==2  (set "DESC=Office Business (US+BR+MX)"                     & set "XML=XMLFiles/InstallOffice-Business-US.xml"           & goto run)
if %op%==3  (set "DESC=Office Business (Brazil)"                       & set "XML=XMLFiles/InstallOffice-Business-BR.xml"           & goto run)
if %op%==4  (set "DESC=Office Enterprise + Project + Visio (US+BR+MX)" & set "XML=XMLFiles/InstallOfficeProjectVisio-Enterprise.xml" & goto run)
if %op%==5  (set "DESC=Office Enterprise (US+BR+MX)"                   & set "XML=XMLFiles/InstallOffice-Enterprise-US.xml"         & goto run)
if %op%==6  (set "DESC=Office Enterprise (Brazil)"                     & set "XML=XMLFiles/InstallOffice-Enterprise-BR.xml"         & goto run)
if %op%==7  (set "DESC=Office Home + Project + Visio (US+BR+MX)"       & set "XML=XMLFiles/InstallOfficeProjectVisio-Home.xml"      & goto run)
if %op%==8  (set "DESC=Office Home (US+BR+MX)"                         & set "XML=XMLFiles/InstallOffice-Home-US.xml"               & goto run)
if %op%==9  (set "DESC=Office Home (Brazil)"                           & set "XML=XMLFiles/InstallOffice-Home-BR.xml"               & goto run)
if %op%==10 (set "DESC=Uninstall All Office Packages"                  & set "XML=XMLFiles/UninstallOffice.xml"                     & goto run)

:run
echo.
echo Running: %DESC%, please wait...
"%SETUP_EXE%" /configure "%XML%"
goto end

:end
echo.
echo ============================================================
echo Process finished. Please check if the Office Setup started.
echo Cleaning up temporary files...
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1
if exist "%SETUP_DIR%" rmdir "%SETUP_DIR%" >nul 2>&1
pause
exit
