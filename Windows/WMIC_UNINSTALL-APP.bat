:: RAPHAEL FREI - 2022

@echo off

:: BatchGotAdmin
:-------------------------------------
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"

if '%errorlevel%' NEQ '0' (
    echo Requisitando acesso de administrador...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params = %*:"=""
    echo UAC.ShellExecute "cmd.exe", "/c %~s0 %params%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------

echo Colecting Information...

::Opens WMIC and collects name and version of all programs
WMIC product get name, version

set /p PRG="Insert the name to uninstall: "
IF NOT DEFINED PRG SET /p PRG="Insert the name to uninstall: "

::Uninstall app
wmic product where name="%PRG%" call uninstall /nointeractive

pause