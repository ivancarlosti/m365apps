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
  exit /b
)
cmd /u /c echo Set UAC = CreateObject^("Shell.Application"^) : UAC.ShellExecute "%~0", "%Variable%", "", "runas", 1 > "%temp%\getadmin.vbs"
cscript //nologo "%temp%\getadmin.vbs"
exit /b

:Privileges_got
setlocal EnableExtensions
cd /d "%~dp0"

set "SETUP_URL=https://officecdn.microsoft.com/pr/wsus/setup.exe"
set "SETUP_DIR=%temp%\m365apps"
set "SETUP_EXE=%SETUP_DIR%\setup.exe"

:menu
cls
echo ============================================================
echo                MICROSOFT OFFICE INSTALLER
echo ============================================================
echo.
echo  [ INSTALL ]
echo.
echo   1 - Install Office Business + Project + Visio (US+BR+MX)
echo   2 - Install Office Business (US+BR+MX)
echo   3 - Install Office Business (Brazil Only)
echo   4 - Install Office Enterprise + Project + Visio (US+BR+MX)
echo   5 - Install Office Enterprise (US+BR+MX)
echo   6 - Install Office Enterprise (Brazil Only)
echo   7 - Install Office Home + Project + Visio (US+BR+MX)
echo   8 - Install Office Home (US+BR+MX)
echo   9 - Install Office Home (Brazil Only)
echo.
echo  [ UNINSTALL ]
echo.
echo   0 - Uninstall All Office Packages
echo.
echo  [ TWEAKS ]
echo.
echo   A - Allow  OneDrive Personal sync
echo   B - Block  OneDrive Personal sync
echo   C - Remove OneDrive Personal sync policy
echo   D - Show   Office Insider button
echo   E - Hide   Office Insider button
echo   F - Remove Office Insider button policy
echo   G - Remove Office Update Channel policy
echo.
echo   Q - Quit
echo.
echo ============================================================
echo.
choice /c 1234567890ABCDEFGQ /n /m "Selection: "
set "op=%errorlevel%"

set "DESC="
set "XML="

if "%op%"=="1"  set "DESC=Office Business + Project + Visio (US+BR+MX)"    & set "XML=XMLFiles/InstallOfficeProjectVisio-Business.xml"
if "%op%"=="2"  set "DESC=Office Business (US+BR+MX)"                      & set "XML=XMLFiles/InstallOffice-Business-US.xml"
if "%op%"=="3"  set "DESC=Office Business (Brazil)"                        & set "XML=XMLFiles/InstallOffice-Business-BR.xml"
if "%op%"=="4"  set "DESC=Office Enterprise + Project + Visio (US+BR+MX)"  & set "XML=XMLFiles/InstallOfficeProjectVisio-Enterprise.xml"
if "%op%"=="5"  set "DESC=Office Enterprise (US+BR+MX)"                    & set "XML=XMLFiles/InstallOffice-Enterprise-US.xml"
if "%op%"=="6"  set "DESC=Office Enterprise (Brazil)"                      & set "XML=XMLFiles/InstallOffice-Enterprise-BR.xml"
if "%op%"=="7"  set "DESC=Office Home + Project + Visio (US+BR+MX)"        & set "XML=XMLFiles/InstallOfficeProjectVisio-Home.xml"
if "%op%"=="8"  set "DESC=Office Home (US+BR+MX)"                          & set "XML=XMLFiles/InstallOffice-Home-US.xml"
if "%op%"=="9"  set "DESC=Office Home (Brazil)"                            & set "XML=XMLFiles/InstallOffice-Home-BR.xml"
if "%op%"=="10" set "DESC=Uninstall All Office Packages"                   & set "XML=XMLFiles/UninstallOffice.xml"

if defined XML goto runOffice
if "%op%"=="11" goto tweakAllowOneDrive
if "%op%"=="12" goto tweakBlockOneDrive
if "%op%"=="13" goto tweakRemoveOneDrive
if "%op%"=="14" goto tweakShowInsider
if "%op%"=="15" goto tweakHideInsider
if "%op%"=="16" goto tweakRemoveInsider
if "%op%"=="17" goto tweakRemoveBranch
if "%op%"=="18" goto quit
goto menu

:runOffice
echo.
echo ------------------------------------------------------------
echo Preparing Office Deployment Tool...
echo ------------------------------------------------------------
if not exist "%SETUP_DIR%" mkdir "%SETUP_DIR%" >nul 2>&1
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1
echo Downloading the latest setup.exe from Microsoft...
curl.exe -fSL -o "%SETUP_EXE%" "%SETUP_URL%"
if not exist "%SETUP_EXE%" (
    echo.
    echo ERROR: Failed to download setup.exe from Microsoft.
    echo Please check your internet connection and try again.
    echo.
    pause
    goto cleanup
)
echo Download complete.
echo.
echo Running: %DESC%, please wait...
"%SETUP_EXE%" /configure "%XML%"
goto cleanup

:tweakAllowOneDrive
echo.
echo ------------------------------------------------------------
echo Allowing OneDrive Personal sync...
echo ------------------------------------------------------------
reg add "HKCU\Software\Microsoft\OneDrive" /v "DisablePersonalSync" /t REG_DWORD /d 0 /f >nul 2>&1
echo Done.
goto pauseAndMenu

:tweakBlockOneDrive
echo.
echo ------------------------------------------------------------
echo Blocking OneDrive Personal sync...
echo ------------------------------------------------------------
reg add "HKCU\Software\Microsoft\OneDrive" /v "DisablePersonalSync" /t REG_DWORD /d 1 /f >nul 2>&1
echo Done.
goto pauseAndMenu

:tweakRemoveOneDrive
echo.
echo ------------------------------------------------------------
echo Removing OneDrive Personal sync policy...
echo ------------------------------------------------------------
reg delete "HKCU\Software\Microsoft\OneDrive" /v "DisablePersonalSync" /f >nul 2>&1
echo Done.
goto pauseAndMenu

:tweakShowInsider
echo.
echo ------------------------------------------------------------
echo Showing Office Insider button (File ^> Account)...
echo ------------------------------------------------------------
reg add "HKCU\Software\Policies\Microsoft\office\16.0\common" /v "insiderslabbehavior" /t REG_DWORD /d 2 /f >nul 2>&1
echo Done.
goto pauseAndMenu

:tweakHideInsider
echo.
echo ------------------------------------------------------------
echo Hiding Office Insider button...
echo ------------------------------------------------------------
reg add "HKCU\Software\Policies\Microsoft\office\16.0\common" /v "insiderslabbehavior" /t REG_DWORD /d 0 /f >nul 2>&1
echo Done.
goto pauseAndMenu

:tweakRemoveInsider
echo.
echo ------------------------------------------------------------
echo Removing Office Insider button policy...
echo ------------------------------------------------------------
reg delete "HKCU\Software\Policies\Microsoft\office\16.0\common" /v "insiderslabbehavior" /f >nul 2>&1
echo Done.
goto pauseAndMenu

:tweakRemoveBranch
echo.
echo ------------------------------------------------------------
echo Removing Office Update Channel policy...
echo ------------------------------------------------------------
reg delete "HKLM\SOFTWARE\Policies\Microsoft\office\16.0\common\officeupdate" /v "updatebranch" /f >nul 2>&1
echo Done.
goto pauseAndMenu

:pauseAndMenu
echo.
pause
goto menu

:cleanup
echo.
echo ============================================================
echo Process finished. Please check if the Office Setup started.
echo Cleaning up temporary files...
if exist "%SETUP_EXE%" del /f /q "%SETUP_EXE%" >nul 2>&1
if exist "%SETUP_DIR%" rmdir "%SETUP_DIR%" >nul 2>&1
echo.
pause
goto menu

:quit
endlocal
exit /b
