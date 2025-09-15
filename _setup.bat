@echo off
chcp 65001
cls

:begin
echo Selecione a opção desejada:
echo.
echo 1) Instalar Office Business (O365BusinessRetail) + Project + Visio - US+BR+MX
echo 2) Instalar Office Business (O365BusinessRetail) - US+BR+MX
echo 3) Instalar Office Business (O365BusinessRetail) - BR
echo 4) Instalar Office Enterprise (O365ProPlusRetail) + Project + Visio - US+BR+MX
echo 5) Instalar Office Enterprise (O365ProPlusRetail) - US+BR+MX
echo 6) Instalar Office Enterprise (O365ProPlusRetail) - BR
echo 7) Instalar Office Home (O365HomePremRetail) + Project + Visio - US+BR+MX
echo 8) Instalar Office Home (O365HomePremRetail) - US+BR+MX
echo 9) Instalar Office Home (O365HomePremRetail) - BR
echo 0) Desinstalar pacotes Office
echo.
set /p op=Digite o número da opção: 
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3
if "%op%"=="4" goto op4
if "%op%"=="5" goto op5
if "%op%"=="6" goto op6
if "%op%"=="7" goto op7
if "%op%"=="8" goto op8
if "%op%"=="9" goto op9
if "%op%"=="0" goto op0

cls
goto begin


:op1
echo Instalação do Office Business (O365BusinessRetail) + Project + Visio - US+BR+MX selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOfficeProjectVisio-Business.xml
goto exit

:op2
echo Instalação do Office Business (O365BusinessRetail) - US+BR+MX selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Business-US.xml
goto exit

:op3
echo Instalação do Office Business (O365BusinessRetail) - BR selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Business-BR.xml
goto exit

:op4
echo Instalação do Office Enterprise (O365ProPlusRetail) + Project + Visio - US+BR+MX selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOfficeProjectVisio-Enterprise.xml
goto exit

:op5
echo Instalação do Office Enterprise (O365ProPlusRetail) - US+BR+MX selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Enterprise-US.xml
goto exit

:op6
echo Instalação do Office Enterprise (O365ProPlusRetail) - BR selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Enterprise-BR.xml
goto exit

:op7
echo Instalação do Office Home (O365HomePremRetail) + Project + Visio - US+BR+MX selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOfficeProjectVisio-Home.xml
goto exit

:op8
echo Instalação do Office Home (O365HomePremRetail) - US+BR+MX selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Home-US.xml
goto exit

:op9
echo Instalação do Office Home (O365HomePremRetail) - BR selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Home-BR.xml
goto exit

:op0
echo Desinstalação do Office selecionado, aguarde.
setup.exe /configure XMLFiles/UninstallOffice.xml
goto exit

:exit
echo Processo finalizado.
pause
@exit
