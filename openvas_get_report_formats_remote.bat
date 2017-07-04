@echo off
setlocal
set LinuxServer=%1
set LinuxUsername=%2
set LinuxPassword=%3
set OpenvasUsername=%4
set OpenvasPassword=%5
set Timestamp=%6

@title=[OpenVAS] - Obteniendo "Format Report ID"...

rem http://docs.greenbone.net/API/OMP/omp.html#command_get_report_formats
"%~dp0pscp.exe" -P 22 -l %LinuxUsername% -pw %LinuxPassword% -C "openvas_get_report_formats_remote.sh" %LinuxServer%:"/tmp/openvas_get_report_formats_remote_1.sh"
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "tr -d '\15\32' < /tmp/openvas_get_report_formats_remote_1.sh > /tmp/openvas_get_report_formats_remote.sh"
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "rm -f '/tmp/openvas_get_report_formats_remote_1.sh'"
"%~dp0plink.exe" -P 22 -ssh -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer% "export TERM=xterm ; cd '/tmp' ; chmod 755 ./openvas_get_report_formats_remote.sh ; ./openvas_get_report_formats_remote.sh '%OpenvasUsername%' '%OpenvasPassword%' '%Timestamp%'"

"%~dp0pscp.exe" -P 22 -l %LinuxUsername% -pw %LinuxPassword% -C %LinuxServer%:"/tmp/openvas_report_formats_%Timestamp%.txt" "%TEMP%\openvas_report_formats_%Timestamp%.txt"

findstr.exe /C:"OK" "%TEMP%\openvas_report_formats_%Timestamp%.txt" >NUL
if %ERRORLEVEL% NEQ 0 ( echo ---Error--- && pause && exit )

echo [Config] 1> "%TEMP%\openvas_report_formats_%Timestamp%.ini"
type "%TEMP%\openvas_report_formats_%Timestamp%.txt" | "%~dp0xml.exe" sel -T -t -m "/get_report_formats_response/report_format" -o "ID" -v "position()"  -o "=" -v "@id" -n -o "Nombre" -v "position()"  -o "=\"" -v "name" -o "\"" -n -o "Extension" -v "position()"  -o "=\"" -v "extension" -o "\"" -n -o "Ultimo=" -v "last()" -n >> "%TEMP%\openvas_report_formats_%Timestamp%.ini"

del /F "%TEMP%\openvas_report_formats_%Timestamp%.txt"