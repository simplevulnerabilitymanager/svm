@echo off
set Server=%1
set Port=%2
set Username=%3
set Password=%4
set Timestamp=%5

@title=[OpenVas] - Obteniendo "Format Report ID"

rem http://docs.greenbone.net/API/OMP/omp.html#command_get_report_formats
"%~dp0omp_cracked.exe" --host=%Server% --port=%Port% --username=%Username% --password=%Password% --xml="<get_report_formats />" 1>"%TEMP%\openvas_get_reports_formats_%Timestamp%.txt" 2>NUL
findstr.exe /C:"OK" "%TEMP%\openvas_get_reports_formats_%Timestamp%.txt"
if not %ERRORLEVEL% EQU 0 ( echo ---Error--- && pause && exit )

"%~dp0xml.exe" fo "%TEMP%\openvas_get_reports_formats_%Timestamp%.txt" > "%TEMP%\openvas_get_reports_formats_%Timestamp%_indented.txt"

notepad.exe "%TEMP%\openvas_get_reports_formats_%Timestamp%_indented.txt"

