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

set /p IP="IPV4 Address: "
echo The IP eis %IP%

echo.
set /p GW="Gateway: "
echo The Gateway is: %GW%

echo.
set /p DNS="DNS: "
IF NOT DEFINED DNS SET "DNS=0.0.0.0"
echo The DNS is: %DNS%

echo.
echo.
echo Setting IP...
timeout 5

netsh interface ipv4 set address "Ethernet" static %IP% 255.255.255.0 %GW%
netsh interface ipv4 set dns name="Ethernet" static %DNS%

cls

echo IP defined!

pause
