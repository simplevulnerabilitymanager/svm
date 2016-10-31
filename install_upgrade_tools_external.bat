@echo off
set Server=%1
set Username=%2
set Password=%3

@title=[Instalando/Actualizando Tools Externas]
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%~dp0install_upgrade_tools_external.sh" %Server%:"/tmp/install_upgrade_tools_external.sh"
if not %ERRORLEVEL% EQU 0 ( echo ---Error--- && pause && exit )
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "tr -d '\15\32' < /tmp/install_upgrade_tools_external.sh > /tmp/install_upgrade_tools_external_dos2unix.sh ; chmod 755 /tmp/install_upgrade_tools_external_dos2unix.sh ; sudo /tmp/install_upgrade_tools_external_dos2unix.sh"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -fr /tmp/install_upgrade_tools_external.sh /tmp/install_upgrade_tools_external_dos2unix.sh"
pause
