@echo off
title Optimizador
:: BatchGotAdmin
:-------------------------------------
REM  --> Check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> If error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"
:--------------------------------------  
echo --------------------------------------------------
echo                 Optimizador
echo --------------------------------------------------
echo.
echo Este script Desactiva y Optimiza servicios
echo de tu sistema operativo
echo.
echo Es recomendable hacer un punto de restauracion
echo Antes de continuar
echo.
echo No me hago cargo de lo que te pueda pasar.
echo Hazlo por tu propio riesgo.
echo.
echo --------------------------------------------------
pause  
net stop uxsms
bcdedit /set useplatformtick yes
bcdedit /set disabledynamictick yes
bcdedit /deletevalue useplatformclock
bcdedit /set nointegritychecks ON
cd %~dp0\data
Echo Activando Modo De Energia...
powercfg -h off
powercfg -import "%~dp0data\modo.pow" a11a11c9-6d83-493e-a38d-d5fa3c620915
powercfg /setactive a11a11c9-6d83-493e-a38d-d5fa3c620915
Echo Borrando Archivos Temporales...
Del /S /F /Q %temp%
Del /S /F /Q %SystemDrive%\Windows\Temp\*.*
Del /S /F /Q %SystemDrive%\Windows\Prefetch\*.*
Echo Optimizando El Registro...
REGEDIT /S optimizacion-Juegos.reg
REGEDIT /S windows-defender.reg
REGEDIT /S optimizacion.reg
REGEDIT /S optimizacion-gpu.reg
REGEDIT /S unpark-cpu.reg
REGEDIT /S uhd.reg
REGEDIT /S telemetria.reg
REGEDIT /S servicios.reg
REGEDIT /S mapas.reg
Echo Optimizando Servicios..
sc config dmwappushservice start= disabled
sc config DiagTrack start= disabled
sc config WSearch start= disabled
sc config WMPNetworkSvc start= disabled
sc config SNMPTRAP start= disabled
sc config SCPolicySvc start= disabled
sc config SCardSvr start= disabled
sc config RemoteRegistry start= disabled
sc config RpcLocator start= disabled
sc config WPCSvc start= disabled
sc config CscService start= disabled
sc config napagent start= disabled
sc config Netlogon start= disabled
sc config MSiSCSI start= disabled
sc config iphlpsvc start= disabled
sc config TrkWks start= disabled
sc config CertPropSvc start= disabled
sc config PeerDistSvc start= disabled
sc config bthserv start= disabled
sc config SysMain start= disabled 
net stop SysMain
Echo Optimizando El Internet...
REGEDIT /S packet.reg
REGEDIT /S red.reg
REGEDIT /S NetworkThrottlingIndex.reg
Echo Optimizacion Completada!
Pause
exit