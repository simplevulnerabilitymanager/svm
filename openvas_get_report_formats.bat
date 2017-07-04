@echo off
setlocal
set OpenvasServer=%1
set OpenvasUsername=%3
set OpenvasPassword=%4
set OpenvasPort=%2
set Timestamp=%5

@title=[OpenVAS] - Obteniendo "Format Report ID"

rem http://docs.greenbone.net/API/OMP/omp.html#command_get_report_formats
"%~dp0omp_cracked.exe" --host=%OpenvasServer% --port=%OpenvasPort% --username=%OpenvasUsername% --password=%OpenvasPassword% --xml="<get_report_formats />" 1>"%TEMP%\openvas_report_formats_%Timestamp%.txt" 2>NUL

findstr.exe /C:"OK" "%TEMP%\openvas_report_formats_%Timestamp%.txt"
if %ERRORLEVEL% NEQ 0 ( echo ---Error--- && pause && exit )

echo [Config] 1> "%TEMP%\openvas_report_formats_%Timestamp%.ini"
type "%TEMP%\openvas_report_formats_%Timestamp%.txt" | "%~dp0xml.exe" sel -T -t -m "/get_report_formats_response/report_format" -o "ID" -v "position()"  -o "=" -v "@id" -n -o "Nombre" -v "position()"  -o "=\"" -v "name" -o "\"" -n -o "Extension" -v "position()"  -o "=\"" -v "extension" -o "\"" -n -o "Ultimo=" -v "last()" -n >> "%TEMP%\openvas_report_formats_%Timestamp%.ini"

del /F "%TEMP%\openvas_report_formats_%Timestamp%.txt"