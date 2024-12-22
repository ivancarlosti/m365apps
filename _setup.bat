@echo off
chcp 65001
cls

:begin
echo Selecione a opção desejada:
echo.
echo 1) Instalar Office Business (O365BusinessRetail) + Project + Visio - EN+PT+ES
echo 2) Instalar Office Enterprise (O365ProPlusRetail) + Project + Visio - EN+PT+ES
echo 3) Instalar Office Home (O365HomePremRetail) + Project + Visio - EN+PT+ES
echo 4) Instalar Office Business (O365BusinessRetail) - PT
echo 5) Instalar Office Enterprise (O365ProPlusRetail) - PT
echo 9) Desinstalar pacotes Office
echo.
set /p op=Digite o número da opção: 
if "%op%"=="1" goto op1
if "%op%"=="2" goto op2
if "%op%"=="3" goto op3
if "%op%"=="4" goto op4
if "%op%"=="5" goto op5
if "%op%"=="9" goto op9

cls
goto begin


:op1
echo Instalação do Office Business + Project + Visio selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOfficeProjectVisio-Business.xml
goto exit

:op2
echo Instalação do Office Enterprise + Project + Visio selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOfficeProjectVisio-Enterprise.xml
goto exit

:op3
echo Instalação do Office Home + Project + Visio selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOfficeProjectVisio-Home.xml
goto exit

:op4
echo Instalação do Office Business selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Business.xml
goto exit

:op5
echo Instalação do Office Enterprise selecionado, aguarde.
setup.exe /configure XMLFiles/InstallOffice-Enterprise.xml
goto exit

:op9
echo Desinstalação do Office selecionado, aguarde.
setup.exe /configure XMLFiles/UninstallOffice.xml
goto exit

:exit
echo Processo finalizado.
pause
@exit
