@echo off
set Proyecto=%1
set IP=%2
set Username=%3
set Password=%4
set Server=%5
set Port=%6
set Policy_ID=%7
set Timestamp=%8
set Documentacion=%9

set Documentacion=%Documentacion:"=%
set Proyecto=%Proyecto:"=%
set Proyecto=%Proyecto:^^~=%
set Proyecto=%Proyecto:^^&=%
set Proyecto=%Proyecto:^*=%
set Proyecto=%Proyecto::=%
set Proyecto=%Proyecto:^<=%
set Proyecto=%Proyecto:^>=%
set Proyecto=%Proyecto:?=%
set Proyecto=%Proyecto:^|=%
set Proyecto=%Proyecto:^==%
set Proyecto=%Proyecto:$=%
set Proyecto=%Proyecto:^^=%
set Timestamp=%Timestamp:"=%
set Documentacion="%Documentacion%\NessusReport - %Proyecto% - %Timestamp%.html"

@title=[Nessus Scan] - %Proyecto%

"%~dp0curl.exe" -s -k https://%Server%:%Port%/ > NUL
if %ERRORLEVEL% neq 0 ( echo ---Nessus Service no iniciado. Loguearse por ssh a %Server% y ejecutar: && echo /etc/init.d/nessusd start && pause && exit )

rem Login
"%~dp0curl.exe" -s -k -X POST -H "Content-Type: application/json" -d "{\"username\":\"%Username%\",\"password\":\"%Password%\"}" https://%Server%:%Port%/session | "%~dp0jq-win32.exe" .token > "%TEMP%\nessus_scan_token_%Timestamp%.txt"
set /p TOKEN=<"%TEMP%\nessus_scan_token_%Timestamp%.txt"
set TOKEN=%TOKEN:"=%
if /I %TOKEN% == null ( echo ---Error--- && pause && exit )

rem Add New Scan
"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -d "{\"uuid\": \"%Policy_ID%\", \"settings\": {\"name\": \"%Proyecto%\", \"description\": \"\", \"text_targets\": \"%IP%\"}" https://%Server%:%Port%/scans | "%~dp0jq-win32.exe" .scan.id > "%TEMP%\nessus_scan_id_%Timestamp%.txt"
set /p ID_SCAN=<"%TEMP%\nessus_scan_id_%Timestamp%.txt"

rem Launch a Scan
"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -d "" https://%Server%:%Port%/scans/%ID_SCAN%/launch > "%TEMP%\nessus_scan_launch_%Timestamp%.txt"

cls

rem Details Scans
echo Escaneando...
:while1
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" https://%Server%:%Port%/scans/%ID_SCAN% | "%~dp0jq-win32.exe" .info.status > "%TEMP%\nessus_scan_status_scan_%Timestamp%.txt"
set /p STATUS=<"%TEMP%\nessus_scan_status_scan_%Timestamp%.txt"
if %STATUS% == "null" ( echo ---Error--- && pause && exit )
if %STATUS% == "completed" ( echo: ) else ( ping -n 61 127.0.0.1 > NUL && time /T && goto :while1 )



echo Generando Reporte...
rem Export Scan
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" https://%Server%:%Port%/scans/%ID_SCAN% | "%~dp0jq-win32.exe" ".history[].history_id" > "%TEMP%\nessus_scan_history_id_%Timestamp%.txt"
set /p HISTORY_ID=<"%TEMP%\nessus_scan_history_id_%Timestamp%.txt"

"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -d "{\"format\":\"html\",\"chapters\":\"vuln_by_plugin\"}" https://%Server%:%Port%/scans/%ID_SCAN%/export?history_id=%HISTORY_ID% | "%~dp0jq-win32.exe" ".file" > "%TEMP%\nessus_scan_file_%Timestamp%.txt"
set /p FILE=<"%TEMP%\nessus_scan_file_%Timestamp%.txt"

rem Export Status
:while2
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" https://%Server%:%Port%/scans/%ID_SCAN%/export/%FILE%/status | "%~dp0jq-win32.exe" .status > "%TEMP%\nessus_scan_status_report_%Timestamp%.txt"
set /p STATUS_REPORT=<"%TEMP%\nessus_scan_status_report_%Timestamp%.txt"
if %STATUS_REPORT% == "null" ( echo ---Error--- && pause && exit )
if %STATUS_REPORT% == "ready" ( echo: ) else ( ping -n 11 127.0.0.1 > NUL && echo . && goto :while2 )


"%~dp0curl.exe" -s -k https://%Server%:%Port%/scans/%ID_SCAN%/export/%FILE%/download?token=%TOKEN% --output %Documentacion%

rem Logout
"%~dp0curl.exe" -s -k -X DELETE -H "X-Cookie: token=%TOKEN%" https://%Server%:%Port%/session >NUL

del /F "%TEMP%\nessus_scan_token_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_id_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_status_scan_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_launch_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_history_id_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_file_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_status_report_%Timestamp%.txt"

echo %Documentacion%
start "" /WAIT /I ""%Documentacion%""

pause
