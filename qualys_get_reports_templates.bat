@echo off
setlocal
set Username=%1
set Password=%2
set Timestamp=%3
set UsoProxy=%4
set ProxyIP=%5
set ProxyPort=%6
set ProxyUser=%7
set ProxyPassword=%8

@title=[Qualys] - Obteniendo "Reports Template"

if %UsoProxy% EQU 1 ( set Proxy=--proxy %ProxyIP%:%ProxyPort% --proxy-anyauth --proxy-user %ProxyUser%:%ProxyPassword% )
if %UsoProxy% EQU 0 ( set Proxy= )

rem Reports Template ID
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl SVM" --user %Username%:%Password% "https://qualysapi.qualys.com/msp/report_template_list.php" -o "%TEMP%\qualys_reports_templates_%Timestamp%.txt" 2> NUL

echo [Config] 1> "%TEMP%\qualys_reports_templates_%Timestamp%.ini"
type "%TEMP%\qualys_reports_templates_%Timestamp%.txt" | "%~dp0xml.exe" sel -T -t -m "/REPORT_TEMPLATE_LIST/REPORT_TEMPLATE" -o "ID" -v "position()"  -o "=" -v "ID" -n -o "Nombre" -v "position()" -o "=\"" -v "TITLE" -o "\""  -n -o "Tipo" -v "position()" -o "=\"" -v "TEMPLATE_TYPE" -o "\"" -n -o "Ultimo=" -v "last()" -n 1>> "%TEMP%\qualys_reports_templates_%Timestamp%.ini" 2>NUL

del /F "%TEMP%\qualys_reports_templates_%Timestamp%.txt"
