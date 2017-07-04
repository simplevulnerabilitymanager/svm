@echo off
setlocal
set Server=%1
set Username=%2
set Password=%3
set Tool=%4

@title=[Tools Instalar/Actualizar (Remoto) - %Tool%]

"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%~dp0install_upgrade_tools_remoto.sh" %Server%:"/tmp/install_upgrade_tools_remoto_1.sh"
if %ERRORLEVEL% NEQ 0 ( echo ---Error--- && pause && exit )
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "tr -d '\15\32' < /tmp/install_upgrade_tools_remoto_1.sh > /tmp/install_upgrade_tools_remoto.sh"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "chmod 755 /tmp/install_upgrade_tools_remoto.sh"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "sudo /tmp/install_upgrade_tools_remoto.sh %Tool%" 
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -fr /tmp/install_upgrade_tools_remoto_1.sh /tmp/install_upgrade_tools_remoto.sh"
pause
