@echo off
setlocal
set Proyecto=%1
set URL=%2
set APIURL=%3
set APIKEY=%4
set Documentacion=%5
set Timestamp=%6
set NRO=%7

set Documentacion=%Documentacion:"=%
set DocumentacionHTML="%Documentacion%\AcunetixReport - %Timestamp%.html"
set DocumentacionPDF="%Documentacion%\AcunetixReport - %Timestamp%.pdf"

set Proyecto=%Proyecto:"=%
@title=[Acunetix Scan v11/v12] - %Proyecto% - %URL%

set /a SLEEP=%NRO%*20
ping -n %SLEEP% 127.0.0.1 > NUL


rem Acunetix v11.0/v12.0
rem Add Target
"%~dp0curl.exe" -s -k -X POST -H "Content-Type: application/json" -H "X-Auth: %APIKEY%" --data-urlencode "{\"address\":\"%URL%\",\"description\":\"%Proyecto%\",\"criticality\":\"10\"}" "%APIURL%/api/v1/targets" | "%~dp0jq-win32.exe" .target_id > "%TEMP%\acunetix11_add_target_%Timestamp%-URL_%NRO%.txt"
set /p TARGET_ID=<"%TEMP%\acunetix11_add_target_%Timestamp%-URL_%NRO%.txt"
set TARGET_ID=%TARGET_ID:"=%
if /I %TARGET_ID% == null ( echo Error: Generando Target && pause && exit )

rem 2 Config Scan
rem data = {"excluded_paths":["manager","phpmyadmin","testphp"],"user_agent":"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36","custom_headers":["Accept: */*","Connection: Keep-alive"],"custom_cookies":[{"url":url,"cookie":"UM_distinctid=15da1bb9287f05-022f43184eb5d5-30667808-fa000-15da1bb9288ba9; PHPSESSID=dj9vq5fso96hpbgkdd7ok9gc83"}],"scan_speed":"moderate","technologies":["PHP"],"proxy": {"enabled":False,"address":"127.0.0.1","protocol":"http","port":8080,"username":"aaa","password":"bbb"},"login":{"kind": "automatic","credentials": {"enabled": False,"username": "test","password": "test"}},"authentication":{"enabled":False,"username":"test","password":"test"}}
rem "{\"excluded_paths\":[\"manager\",\"phpmyadmin\",\"testphp\"],\"user_agent\":\"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36\",\"custom_headers\":[\"Accept: */*\",\"Connection: Keep-alive\"],\"custom_cookies\":[{\"url\":url,\"cookie\":\"UM_distinctid=15da1bb9287f05-022f43184eb5d5-30667808-fa000-15da1bb9288ba9; PHPSESSID=dj9vq5fso96hpbgkdd7ok9gc83\"}],\"scan_speed\":\"moderate\",\"technologies\":[\"PHP\"],\"proxy\": {\"enabled\":False,\"address\":\"127.0.0.1\",\"protocol\":\"http\",\"port\":8080,\"username\":\"aaa\",\"password\":\"bbb\"},\"login\":{\"kind\": \"automatic\",\"credentials\": {\"enabled\": False,\"username\": \"test\",\"password\": \"test\"}},\"authentication\":{\"enabled\":False,\"username\":\"test\",\"password\":\"test\"}}"

rem https://127.0.0.1:3443/api/v1/targets/9ddc2900-915b-4a47-8c0e-b592d23102de/configuration
rem {"authentication": {"username": "test", "password": "test", "enabled": false}, "proxy": {"username": "aaa", "protocol": "http", "enabled": false, "address": "127.0.0.1", "password": "bbb", "port": 8080}, "custom_headers": ["Accept: */*", "Referer:http://testhtml5.vulnweb.com/", "Connection: Keep-alive"], "excluded_paths": ["manager", "phpmyadmin", "testphp"], "custom_cookies": [{"url": "http://testhtml5.vulnweb.com/", "cookie": "UM_distinctid=15da1bb9287f05-022f43184eb5d5-30667808-fa000-15da1bb9288ba9; PHPSESSID=dj9vq5fso96hpbgkdd7ok9gc83"}], "login": {"credentials": {"username": "test", "password": "test", "enabled": false}, "kind": "automatic"}, "technologies": ["PHP"], "scan_speed": "moderate", "user_agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36"}
rem {\"authentication\": {\"username\": \"test\", \"password\": \"test\", \"enabled\": false}, \"proxy\": {\"username\": \"aaa\", \"protocol\": \"http\", \"enabled\": false, \"address\": \"127.0.0.1\", \"password\": \"bbb\", \"port\": 8080}, \"custom_headers\": [\"Accept: */*\", \"Referer:http://testhtml5.vulnweb.com/\", \"Connection: Keep-alive\"], \"excluded_paths\": [\"manager\", \"phpmyadmin\", \"testphp\"], \"custom_cookies\": [{\"url\": \"http://testhtml5.vulnweb.com/\", \"cookie\": \"UM_distinctid=15da1bb9287f05-022f43184eb5d5-30667808-fa000-15da1bb9288ba9; PHPSESSID=dj9vq5fso96hpbgkdd7ok9gc83\"}], \"login\": {\"credentials\": {\"username\": \"test\", \"password\": \"test\", \"enabled\": false}, \"kind\": \"automatic\"}, \"technologies\": [\"PHP\"], \"scan_speed\": \"moderate\", \"user_agent\": \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36\"}
rem "%~dp0curl.exe" -k -X PATCH -H "Content-Type: application/json" -H "X-Auth: %APIKEY%" -d  "{\"authentication\": {\"username\": \"test\", \"password\": \"test\", \"enabled\": false}, \"proxy\": {\"username\": \"aaa\", \"protocol\": \"http\", \"enabled\": false, \"address\": \"127.0.0.1\", \"password\": \"bbb\", \"port\": 8080}, \"custom_headers\": [\"Accept: */*\", \"Referer:http://testhtml5.vulnweb.com/\", \"Connection: Keep-alive\"], \"excluded_paths\": [\"manager\", \"phpmyadmin\", \"testphp\"], \"custom_cookies\": [{\"url\": \"http://testhtml5.vulnweb.com/\", \"cookie\": \"UM_distinctid=15da1bb9287f05-022f43184eb5d5-30667808-fa000-15da1bb9288ba9; PHPSESSID=dj9vq5fso96hpbgkdd7ok9gc83\"}], \"login\": {\"credentials\": {\"username\": \"test\", \"password\": \"test\", \"enabled\": false}, \"kind\": \"automatic\"}, \"technologies\": [\"PHP\"], \"scan_speed\": \"moderate\", \"user_agent\": \"Mozilla/5.0 (Macintosh; Intel Mac OS X 10_12_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/59.0.3071.115 Safari/537.36\"}" %APIURL%/api/v1/targets/%TARGET_ID%/configuration > configuracion_target.txt
rem res = requests.patch(tarurl+"/api/v1/targets/"+str(target_id)+"/configuration",data=json.dumps(data),headers=headers,timeout=30*4,verify=False)

rem List of built-in scanning profiles:
rem Full Scan: 11111111-1111-1111-1111-111111111111
rem High Risk Vulnerabilities: 11111111-1111-1111-1111-111111111112
rem Cross-site Scripting Vulnerabilities: 11111111-1111-1111-1111-111111111116
rem SQL Injection Vulnerabilities: 11111111-1111-1111-1111-111111111113
rem Weak Passwords: 11111111-1111-1111-1111-111111111115
rem Crawl Only: 11111111-1111-1111-1111-111111111117

rem Start Scan
"%~dp0curl.exe" -s -D - -k -X POST -H "Content-Type: application/json" -H "X-Auth: %APIKEY%" -d "{\"profile_id\": \"11111111-1111-1111-1111-111111111111\", \"target_id\": \"%TARGET_ID%\", \"schedule\": {\"disable\": false, \"time_sensitive\": false, \"start_date\": null}}" "%APIURL%/api/v1/scans" > "%TEMP%\acunetix11_location_%Timestamp%-URL_%NRO%.txt"
findstr /C:"Location:" "%TEMP%\acunetix11_location_%Timestamp%-URL_%NRO%.txt" > "%TEMP%\acunetix11_scan_id_%Timestamp%-URL_%NRO%.txt"
set /p SCAN_ID=<"%TEMP%\acunetix11_scan_id_%Timestamp%-URL_%NRO%.txt"
for %%g in (%SCAN_ID%) do set SCAN_ID=%%~nxg
if /I %SCAN_ID% == null ( echo Error: Iniciando Scan && pause && exit )


rem 4 Get Status Scans
echo Escaneando...
:scan1
"%~dp0curl.exe" -s -k -H "Content-Type: application/json" -H "X-Auth: %APIKEY%" "%APIURL%/api/v1/scans/%SCAN_ID%" | "%~dp0jq-win32.exe" .current_session.status > "%TEMP%\acunetix11_current_session_status_%Timestamp%-URL_%NRO%.txt"
set /p SCAN_STATUS=<"%TEMP%\acunetix11_current_session_status_%Timestamp%-URL_%NRO%.txt"
for %%g in (%SCAN_STATUS%) do set SCAN_STATUS=%%~nxg
if /I %SCAN_STATUS% == null ( echo Error: Se detuvo el escaneo && pause && exit )
if "%SCAN_STATUS%" == "failed" ( echo Error: Error en el escaneo && pause && exit )
if "%SCAN_STATUS%" == "aborting" ( echo Error: Scaneo detenido && pause && exit )
if "%SCAN_STATUS%" == "completed" ( echo: ) else ( ping -n 61 127.0.0.1 > NUL && time /T && goto :scan1 )
rem aborting
rem completed
rem failed
rem processing
rem queued
rem scheduled
rem starting



rem List of built-in report templates and their IDs:
rem Developer: 11111111-1111-1111-1111-111111111111
rem Quick: 11111111-1111-1111-1111-111111111112
rem Executive Summary: 11111111-1111-1111-1111-111111111113
rem HIPAA: 11111111-1111-1111-1111-111111111114
rem Affected Items: 11111111-1111-1111-1111-111111111115
rem Scan Comparison: 11111111-1111-1111-1111-111111111124
rem CWE 2011: 11111111-1111-1111-1111-111111111116
rem ISO 27001: 11111111-1111-1111-1111-111111111117
rem NIST SP800 53: 11111111-1111-1111-1111-111111111118
rem OWASP Top 10 2013: 11111111-1111-1111-1111-111111111119
rem OWASP Top 10 2017: 11111111-1111-1111-1111-111111111125
rem PCI DSS 3.2: 11111111-1111-1111-1111-111111111120
rem Sarbanes Oxley: 11111111-1111-1111-1111-111111111121
rem STIG DISA: 11111111-1111-1111-1111-111111111122
rem WASC Threat Classification: 11111111-1111-1111-1111-111111111123

rem Generate Report
echo Generando Reporte...
"%~dp0curl.exe" -s -D - -k -X POST -H "Content-Type: application/json" -H "X-Auth: %APIKEY%" -d "{\"template_id\":\"11111111-1111-1111-1111-111111111115\",\"source\":{\"list_type\":\"scans\",\"id_list\":[\"%SCAN_ID%\"]}}" "%APIURL%/api/v1/reports" > "%TEMP%\acunetix11_location_report_%Timestamp%-URL_%NRO%.txt"
findstr /C:"Location:" "%TEMP%\acunetix11_location_report_%Timestamp%-URL_%NRO%.txt" > "%TEMP%\acunetix11_report_id_%Timestamp%-URL_%NRO%.txt"
set /p REPORT_ID=<"%TEMP%\acunetix11_report_id_%Timestamp%-URL_%NRO%.txt"
for %%g in (%REPORT_ID%) do set REPORT_ID=%%~nxg
if /I %REPORT_ID% == null ( echo Error: No se genero el Reporte && pause && exit )	

rem Get Status Report
:doc1
"%~dp0curl.exe" -s -k -H "Content-Type: application/json" -H "X-Auth: %APIKEY%" "%APIURL%/api/v1/reports/%REPORT_ID%" > "%TEMP%\acunetix11_report_status_%Timestamp%-URL_%NRO%.txt"
type "%TEMP%\acunetix11_report_status_%Timestamp%-URL_%NRO%.txt" | "%~dp0jq-win32.exe" .status > "%TEMP%\acunetix11_report_field_status_%Timestamp%-URL_%NRO%.txt"
set /p REPORT_STATUS=<"%TEMP%\acunetix11_report_field_status_%Timestamp%-URL_%NRO%.txt"
if %REPORT_STATUS% == "completed" ( echo: ) else ( ping -n 11 127.0.0.1 > NUL && echo . && goto :doc1 )

rem Get URL download files(HTML/PDF)
type  "%TEMP%\acunetix11_report_status_%Timestamp%-URL_%NRO%.txt" | "%~dp0jq-win32.exe" .download[0] > "%TEMP%\acunetix11_report_download_html_%Timestamp%-URL_%NRO%.txt"
type  "%TEMP%\acunetix11_report_status_%Timestamp%-URL_%NRO%.txt" | "%~dp0jq-win32.exe" .download[1] > "%TEMP%\acunetix11_report_download_pdf_%Timestamp%-URL_%NRO%.txt"

rem Parse download link HTML
for /f "tokens=* delims=" %%a in ( 'type "%TEMP%\acunetix11_report_download_html_%Timestamp%-URL_%NRO%.txt"') do ( set DOWNLOAD_HTML=%%a && goto _ExitForHTML )
:_ExitForHTML
set DOWNLOAD_HTML=%DOWNLOAD_HTML:"=%

rem Parse download link PDF
for /f "tokens=* delims=" %%a in ( 'type "%TEMP%\acunetix11_report_download_pdf_%Timestamp%-URL_%NRO%.txt"' ) do ( set DOWNLOAD_PDF=%%a && goto _ExitForPDF )
:_ExitForPDF
set DOWNLOAD_PDF=%DOWNLOAD_PDF:"=%



rem Download Files
"%~dp0curl.exe" -s -k -H "X-Auth: %APIKEY%" "%APIURL%%DOWNLOAD_HTML%" -o %DocumentacionHTML% && echo %DocumentacionHTML% && start "" /WAIT /I ""%DocumentacionHTML%"" 
"%~dp0curl.exe" -s -k -H "X-Auth: %APIKEY%" "%APIURL%%DOWNLOAD_PDF%" -o %DocumentacionPDF% && echo %DocumentacionPDF%

del /F "%TEMP%\acunetix11_add_target_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_location_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_scan_id_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_current_session_status_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_report_id_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_report_status_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_report_download_html_%Timestamp%-URL_%NRO%.txt"
del /F "%TEMP%\acunetix11_report_download_pdf_%Timestamp%-URL_%NRO%.txt"

pause