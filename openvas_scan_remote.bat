@echo off
setlocal
set Proyecto=%1
set IP=%2
set LinuxServer=%3
set LinuxUsername=%4
set LinuxPassword=%5
set OpenvasUsername=%6
set OpenvasPassword=%7
set ScanConfig=%8
set FormatReport=%9
shift
shift
set Documentacion=%8
set Timestamp=%9

set IP=%IP:"=%
set Proyecto=%Proyecto:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\OpenvasReport - %Timestamp%.html"

@title=[OpenVAS Scan (Remote)] - %Proyecto%

"%~dp0pscp.exe" -l %LinuxUsername% -pw %LinuxPassword% -C "openvas_scan_remote.sh" %LinuxServer%:"/tmp/openvas_scan_remote_1.sh"
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "tr -d '\15\32' < /tmp/openvas_scan_remote_1.sh > /tmp/openvas_scan_remote.sh"
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/openvas_scan_remote_1.sh'"

cls
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "export TERM=xterm ; cd '/tmp' ; chmod 755 ./openvas_scan_remote.sh ; ./openvas_scan_remote.sh '%Proyecto%' '%IP%' '%OpenvasUsername%' '%OpenvasPassword%' '%ScanConfig%' '%FormatReport%' '%Timestamp%'"
if %ERRORLEVEL% NEQ 0 ( echo ---Error--- && pause && exit )

"%~dp0pscp.exe" -P 22 -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer%:"/tmp/OpenvasReport - %Timestamp%.html" %Documentacion% > NUL
if %ERRORLEVEL% NEQ 0 ( echo ---Error--- && pause && exit )

"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/OpenvasReport - %Timestamp%.html'"
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/openvas_scan_remote.sh'"

echo %Documentacion%
start "" /WAIT /I ""%Documentacion%""

pause