@echo off
setlocal
set Server=%1
set Port=%2
set Username=%3
set Password=%4
set Timestamp=%5

@title=[Nessus] - Obteniendo Templates

echo Obteniendo Templates...

"%~dp0curl.exe" -s -k https://%Server%:%Port%/ > NUL
if %ERRORLEVEL% NEQ 0 ( echo Nessus Service no iniciado. Loguearse por ssh a %Server% y ejecutar: && echo /etc/init.d/nessusd start && pause && exit )

rem Login
"%~dp0curl.exe" -s -k -X POST -H "Content-Type: application/json" -H "Accept: text/plain" -d "{\"username\":\"%Username%\",\"password\":\"%Password%\"}" https://%Server%:%Port%/session | "%~dp0jq-win32.exe" .token > "%TEMP%\nessus_scan_token_%Timestamp%.txt"
set /p TOKEN=<"%TEMP%\nessus_scan_token_%Timestamp%.txt"
set TOKEN=%TOKEN:"=%
if /I %TOKEN% == null ( echo Revise Usuario/Contraseña si son correctos && pause && exit )

rem "%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/editor/scan/templates | "%~dp0jq-win32.exe"  ".templates[].title" >> "%TEMP%\nessus_scan_policies_%Timestamp%.txt"
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/policies | "%~dp0jq-win32.exe" ".policies[].name" >> "%TEMP%\nessus_scan_policies_%Timestamp%.txt"

rem Logout
"%~dp0curl.exe" -s -k -X DELETE -H "X-Cookie: token=%TOKEN%" -H "Content-Type: application/json" -H "Accept: text/plain" https://%Server%:%Port%/session >NUL

del /F "%TEMP%\nessus_scan_token_%Timestamp%.txt"
