@echo off
set Server=%1
set Port=%2
set Username=%3
set Password=%4
set Timestamp=%5

@title=[Nessus] - Obteniendo Policies

"%~dp0curl.exe" -s -k https://%Server%:%Port%/
if %ERRORLEVEL% neq 0 ( echo ---Nessus Service no iniciado--- && pause && exit )

rem Login
"%~dp0curl.exe" -s -k -X POST -H "Content-Type: application/json" -d "{\"username\":\"%Username%\",\"password\":\"%Password%\"}" https://%Server%:%Port%/session | "%~dp0jq-win32.exe" .token > "%TEMP%\nessus_scan_token_%Timestamp%.txt"

set /p TOKEN=<"%TEMP%\nessus_scan_token_%Timestamp%.txt"
set TOKEN=%TOKEN:"=%
if /I %TOKEN% == null ( echo ---Error--- && pause && exit )

rem List Policies
"%~dp0curl.exe" -s -k -H "X-Cookie: token=%TOKEN%" https://%Server%:%Port%/editor/policy/templates | "%~dp0jq-win32.exe" ".templates[].uuid, .templates[].title" > "%TEMP%\nessus_scan_policies_%Timestamp%.txt"

rem Logout
"%~dp0curl.exe" -s -k -X DELETE -H "X-Cookie: token=%TOKEN%" https://%Server%:%Port%/session >NUL

notepad.exe "%TEMP%\nessus_scan_policies_%Timestamp%.txt"

del /F "%TEMP%\nessus_scan_policies_%Timestamp%.txt"
del /F "%TEMP%\nessus_scan_token_%Timestamp%.txt"
