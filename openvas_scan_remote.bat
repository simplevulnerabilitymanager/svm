@echo off
setlocal
set Proyecto=%1
set IP=%2
set LinuxServer=%3
set LinuxUsername=%4
set LinuxPassword=%5
set OpenvasmdIP=%6
set OpenvasmdPort=%7
set OpenvasUsername=%8
set OpenvasPassword=%9
shift
shift
shift
shift
set ScanConfig=%6
set FormatReport=%7
set Documentacion=%8
set Timestamp=%9

set IP=%IP:"=%
set Proyecto=%Proyecto:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\OpenvasReport - %Timestamp%.html"

@title=[OpenVAS Scan (Remoto SSH)] - %Proyecto%

"%~dp0pscp.exe" -l %LinuxUsername% -pw %LinuxPassword% -C "%~dp0openvas_scan_remote.sh" %LinuxServer%:"/tmp/openvas_scan_remote_1.sh"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "tr -d '\15\32' < /tmp/openvas_scan_remote_1.sh > /tmp/openvas_scan_remote.sh"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/openvas_scan_remote_1.sh'"

cls
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "export TERM=xterm ; cd '/tmp' ; chmod 755 ./openvas_scan_remote.sh ; ./openvas_scan_remote.sh '%Proyecto%' '%IP%' '%OpenvasUsername%' '%OpenvasPassword%' '%OpenvasmdIP%' '%OpenvasmdPort%' '%ScanConfig%' '%FormatReport%' '%Timestamp%'"
if %ERRORLEVEL% NEQ 0 ( echo ---Error-1--- && pause && exit )

"%~dp0pscp.exe" -P 22 -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer%:"/tmp/OpenvasReport - %Timestamp%.html" %Documentacion% > NUL
if %ERRORLEVEL% NEQ 0 ( echo ---Error-2--- && pause && exit )

"%~dp0plink.exe" -no-antispoof -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/OpenvasReport - %Timestamp%.html'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/openvas_scan_remote.sh'"

echo %Documentacion%
start "" /WAIT /I ""%Documentacion%""

pause