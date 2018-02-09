@echo off
setlocal
set Proyecto=%1
set IP=%2
set Username=%3
set Password=%4
set Server=%5
set Port=%6
set Policy_Name=%7
set Timestamp=%8
set Documentacion=%9

set Documentacion=%Documentacion:"=%
set Proyecto=%Proyecto:"=%

set DocumentacionHTML="%Documentacion%\NessusReport - %Timestamp%.html"
set DocumentacionXML="%Documentacion%\NessusReport - %Timestamp%.xml"

set SCAN=0

@title=[Nessus Scan] - %Proyecto%

rem Detect Service Up
"%~dp0curl.exe" -s -k https://%Server%:%Port%/ > NUL
if %ERRORLEVEL% NEQ 0 ( echo Nessus Service no iniciado. Loguearse por ssh a %Server% y ejecutar: && echo /etc/init.d/nessusd start && pause && exit )

rem Login
:login1
"%~dp0curl.exe" -s -k -X POST -H "Content-Type: application/json" -H "Accept: text/plain" -d "{\"username\":\"%Username%\",\"password\":\"%Password%\"}" https://%Server%:%Port%/session | "%~dp0jq-win32.exe" .token > "%TEMP%\nessus_scan_token_%Timestamp%.txt"
set /p TOKEN=<"%TEMP%\nessus_scan_token_%Timestamp%.txt"
set TOKEN=%TOKEN:"=%
if /I %TOKEN% == null ( echo ---Error--- && goto :exit1 && exit )
if %SCAN% == 1 ( goto :scan1 )

rem Obtener ID de la Policie
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/policies -o "%TEMP%\nessus_scan_policies_%Timestamp%.txt"
type "%TEMP%\nessus_scan_policies_%Timestamp%.txt" | "%~dp0jq-win32.exe" ".policies[] | select(.name == \"%Policy_Name%\") .id" > "%TEMP%\nessus_scan_policy_id_%Timestamp%.txt"
set /p POLICY_ID=<"%TEMP%\nessus_scan_policy_id_%Timestamp%.txt"

rem Obtener Template UUID
type "%TEMP%\nessus_scan_policies_%Timestamp%.txt" | "%~dp0jq-win32.exe" ".policies[] | select(.name == \"%Policy_Name%\") .template_uuid" > "%TEMP%\nessus_scan_template_uuid_%Timestamp%.txt"
set /p TEMPLATE_UUID=<"%TEMP%\nessus_scan_template_uuid_%Timestamp%.txt"

rem Add New Scan
"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" -d  "{\"uuid\": \"%TEMPLATE_UUID%\", \"settings\": {\"file_targets\": \"\", \"description\": \"SVM Nessus Scan\", \"launch\": \"ON_DEMAND\", \"scanner_id\": \"1\", \"filter_type\": \"\", \"name\": \"%Proyecto%\", \"text_targets\": \"%IP%\", \"owner\": \"%Username%\",  \"filters\": [], \"emails\": \"\", \"policy_id\": %POLICY_ID%}}" https://%Server%:%Port%/scans | "%~dp0jq-win32.exe" ".scan.id" > "%TEMP%\nessus_scan_id_%Timestamp%.txt"
set /p ID_SCAN=<"%TEMP%\nessus_scan_id_%Timestamp%.txt"

rem Launch a Scan
"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" -d "" https://%Server%:%Port%/scans/%ID_SCAN%/launch > "%TEMP%\nessus_scan_launch_%Timestamp%.txt"

rem Details Scans
echo Escaneando...
:scan1
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/scans/%ID_SCAN% | "%~dp0jq-win32.exe" ".info.status" > "%TEMP%\nessus_scan_status_scan_%Timestamp%.txt"
set /p STATUS=<"%TEMP%\nessus_scan_status_scan_%Timestamp%.txt"
if %STATUS% == null ( set SCAN=1 && goto :login1 )
if %STATUS% == "paused" ( echo Paused && ping -n 61 127.0.0.1 > NUL && time /T && goto :scan1)
if %STATUS% == "canceled" ( echo Canceled && goto :exit1 )
if %STATUS% == "completed" ( echo: ) else ( ping -n 61 127.0.0.1 > NUL && time /T && goto :scan1 )


rem Export Scan HTML
echo Generando Reporte HTML...
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/scans/%ID_SCAN% | "%~dp0jq-win32.exe" ".history[].history_id" > "%TEMP%\nessus_scan_history_id_%Timestamp%.txt"
set /p HISTORY_ID=<"%TEMP%\nessus_scan_history_id_%Timestamp%.txt"

"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" -d "{\"format\":\"html\",\"chapters\":\"vuln_hosts_summary;vuln_by_plugin\"}" https://%Server%:%Port%/scans/%ID_SCAN%/export?history_id=%HISTORY_ID% | "%~dp0jq-win32.exe" ".file" > "%TEMP%\nessus_scan_file_%Timestamp%.txt"
set /p FILE=<"%TEMP%\nessus_scan_file_%Timestamp%.txt"

rem Export Status
:doc1
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/scans/%ID_SCAN%/export/%FILE%/status | "%~dp0jq-win32.exe" ".status" > "%TEMP%\nessus_scan_status_report_%Timestamp%.txt"
set /p STATUS_REPORT=<"%TEMP%\nessus_scan_status_report_%Timestamp%.txt"
if %STATUS_REPORT% == null ( echo ---Error--- && pause && exit )
if %STATUS_REPORT% == "ready" ( echo: ) else ( ping -n 11 127.0.0.1 > NUL && echo . && goto :doc1 )

rem Download Doc File
"%~dp0curl.exe" -s -k https://%Server%:%Port%/scans/%ID_SCAN%/export/%FILE%/download?token=%TOKEN% --output %DocumentacionHTML%



rem Export Scan XML
echo Generando Reporte XML...
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/scans/%ID_SCAN% | "%~dp0jq-win32.exe" ".history[].history_id" > "%TEMP%\nessus_scan_history_id_%Timestamp%.txt"
set /p HISTORY_ID=<"%TEMP%\nessus_scan_history_id_%Timestamp%.txt"

"%~dp0curl.exe" -s -k -X POST -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" -d "{\"format\":\"nessus\",\"chapters\":\"vuln_hosts_summary;vuln_by_plugin\"}" https://%Server%:%Port%/scans/%ID_SCAN%/export?history_id=%HISTORY_ID% | "%~dp0jq-win32.exe" ".file" > "%TEMP%\nessus_scan_file_%Timestamp%.txt"
set /p FILE=<"%TEMP%\nessus_scan_file_%Timestamp%.txt"

rem Export Status
:doc2
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/scans/%ID_SCAN%/export/%FILE%/status | "%~dp0jq-win32.exe" ".status" > "%TEMP%\nessus_scan_status_report_%Timestamp%.txt"
set /p STATUS_REPORT=<"%TEMP%\nessus_scan_status_report_%Timestamp%.txt"
if %STATUS_REPORT% == null ( echo ---Error--- && pause && exit )
if %STATUS_REPORT% == "ready" ( echo: ) else ( ping -n 11 127.0.0.1 > NUL && echo . && goto :doc2 )

rem Download Doc File
"%~dp0curl.exe" -s -k https://%Server%:%Port%/scans/%ID_SCAN%/export/%FILE%/download?token=%TOKEN% --output %DocumentacionXML%

rem Logout
"%~dp0curl.exe" -s -k -X DELETE -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/session >NUL


echo %DocumentacionHTML%
start "" /WAIT /I ""%DocumentacionHTML%""

:exit1
del /F "%TEMP%\nessus_scan_token_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_id_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_policies_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_policy_id_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_template_uuid_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_status_scan_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_launch_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_history_id_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_file_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_status_report_%Timestamp%.txt"

pause
