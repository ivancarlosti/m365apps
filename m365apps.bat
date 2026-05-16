@echo off
setlocal
:: Force the script to run from the folder where it is saved.
:: setup.exe will be downloaded here, alongside the XMLFiles\ folder,
:: so we can use relative paths when invoking it.
cd /d "%~dp0"
:: Keep UTF-8 codepage so latin characters render correctly.
chcp 65001 >nul
cls

set "SETUP_EXE=setup.exe"
set "SETUP_URL=https://officecdn.microsoft.com/pr/wsus/setup.exe"

:: --- Download the latest Office Deployment Tool setup.exe -------------------
echo Downloading the latest setup.exe from Microsoft...
where curl.exe >nul 2>&1
if %errorlevel%==0 (
    curl.exe -L -s -o "%SETUP_EXE%" "%SETUP_URL%"
) else (
    powershell -NoProfile -Command "try { [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12; Invoke-WebRequest -Uri '%SETUP_URL%' -OutFile '%SETUP_EXE%' -UseBasicParsing } catch { exit 1 }"
)
if not exist "%SETUP_EXE%" (
    echo.
    echo ERROR: Failed to download setup.exe. Check your internet connection.
    pause
    exit /b 1
)
echo Download complete.
echo.

:: --- Sanity check: XMLFiles folder must sit next to this .bat ---------------
if not exist "XMLFiles\" (
    echo.
    echo ERROR: The XMLFiles folder was not found in:
    echo   %cd%
    echo Make sure you ran m365apps.bat from inside the m365apps folder
    echo and that the XMLFiles folder is present.
    pause
    exit /b 1
)

:menu
echo ============================================================
echo                MICROSOFT OFFICE INSTALLER
echo ============================================================
echo.
echo  1 - Install Office Business + Project + Visio
echo  2 - Install Office Business (US+BR+MX)
echo  3 - Install Office Business (Brazil Only)
echo  4 - Install Office Enterprise + Project + Visio
echo  5 - Install Office Enterprise (US+BR+MX)
echo  6 - Install Office Enterprise (Brazil Only)
echo  7 - Install Office Home + Project + Visio
echo  8 - Install Office Home (US+BR+MX)
echo  9 - Install Office Home (Brazil Only)
echo  0 - Uninstall All Office Packages
echo.
echo ============================================================
echo Please press the number of your choice...
choice /c 1234567890 /n /m "Selection: "
set "op=%errorlevel%"

if "%op%"=="1"  call :run "InstallOfficeProjectVisio-Business.xml"   "Office Business + Project + Visio"   & goto end
if "%op%"=="2"  call :run "InstallOffice-Business-US.xml"            "Office Business (US+BR+MX)"          & goto end
if "%op%"=="3"  call :run "InstallOffice-Business-BR.xml"            "Office Business (Brazil)"            & goto end
if "%op%"=="4"  call :run "InstallOfficeProjectVisio-Enterprise.xml" "Office Enterprise + Project + Visio" & goto end
if "%op%"=="5"  call :run "InstallOffice-Enterprise-US.xml"          "Office Enterprise (US+BR+MX)"        & goto end
if "%op%"=="6"  call :run "InstallOffice-Enterprise-BR.xml"          "Office Enterprise (Brazil)"          & goto end
if "%op%"=="7"  call :run "InstallOfficeProjectVisio-Home.xml"       "Office Home + Project + Visio"       & goto end
if "%op%"=="8"  call :run "InstallOffice-Home-US.xml"                "Office Home (US+BR+MX)"              & goto end
if "%op%"=="9"  call :run "InstallOffice-Home-BR.xml"                "Office Home (Brazil)"                & goto end
if "%op%"=="10" call :run "UninstallOffice.xml"                      "Uninstall Office"                    & goto end

:end
echo.
echo ============================================================
echo Process finished. Please check if the Office Setup started.
pause
exit /b 0

:: --- Subroutine: validate XML, then invoke setup.exe with a relative path ---
:run
set "XML_REL=XMLFiles\%~1"
echo.
echo === %~2 ===
echo Working directory: %cd%
echo Config file (relative): %XML_REL%
if not exist "%XML_REL%" (
    echo.
    echo ERROR: Configuration file not found:
    echo   %cd%\%XML_REL%
    goto :eof
)
echo Running setup.exe...
.\setup.exe /configure "%XML_REL%"
goto :eof
