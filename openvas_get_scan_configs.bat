@echo off
setlocal
set OpenvasServer=%1
set OpenvasUsername=%2
set OpenvasPassword=%3
set OpenvasPort=%4
set Timestamp=%5

@title=[OpenVAS] - Obteniendo "Scan Config ID"

rem http://docs.greenbone.net/API/OMP/omp.html#command_get_configs
"%~dp0omp_cracked.exe" --host=%OpenvasServer% --port=%OpenvasPort% --username=%OpenvasUsername% --password=%OpenvasPassword% --xml="<get_configs />" 1>"%TEMP%\openvas_scan_configs_%Timestamp%.txt" 2>NUL

findstr.exe /C:"OK" "%TEMP%\openvas_scan_configs_%Timestamp%.txt"
if %ERRORLEVEL% NEQ 0 ( echo ---Error--- && pause && exit )

echo [Config] 1> "%TEMP%\openvas_scan_configs_%Timestamp%.ini"
type "%TEMP%\openvas_scan_configs_%Timestamp%.txt" | "%~dp0xml.exe" sel -T -t -m "/get_configs_response/config" -o "ID" -v "position()"  -o "=" -v "@id" -n -o "Nombre" -v "position()"  -o "=\"" -v "name" -o "\"" -n -o "Ultimo=" -v "last()" -n 1>> "%TEMP%\openvas_scan_configs_%Timestamp%.ini" 2>NUL

del /F "%TEMP%\openvas_scan_configs_%Timestamp%.txt"