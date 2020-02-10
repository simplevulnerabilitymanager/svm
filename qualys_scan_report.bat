@echo off
setlocal
set Proyecto=%1
set IP=%2
set Username=%3
set Password=%4
set Documentacion=%5
set TypeReport=%6
set TemplateId=%7
set Timestamp=%8
set UsoProxy=%9
shift
shift
shift
shift
set ProxyIP=%6
set ProxyPort=%7
set ProxyUser=%8
set ProxyPassword=%9

if %UsoProxy% EQU 1 ( set Proxy=--proxy %ProxyIP%:%ProxyPort% --proxy-anyauth --proxy-user %ProxyUser%:%ProxyPassword% )
if %UsoProxy% EQU 0 ( set Proxy= )

set Proyecto=%Proyecto:"=%
set IP=%IP:"=%

@title=[Qualys Scan Report] - %Proyecto%

set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\QualysScanReport - %Timestamp%.%TypeReport%"

echo Generando Reporte...
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -D "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt" --data "action=login" --data "username=%Username%" --data "password=%Password%" "https://qualysapi.qualys.com/api/2.0/fo/session/" -o "%TEMP%\qualys_scan_report_login_%Timestamp%.txt"
findstr.exe /C:"Bad Login/Password" "%TEMP%\qualys_scan_report_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Mal Usuario/Contraseña && pause && exit )

findstr.exe /C:"Service Unavailable" "%TEMP%\qualys_scan_report_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Qualys Planned Maintenance && pause && exit )

findstr.exe /C:"This API cannot be run again" "%TEMP%\qualys_scan_report_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo This API cannot be run again && pause && exit )

"%~dp0curl.exe" -s %Proxy% -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt" --data-urlencode "action=launch" --data-urlencode "ips=%IP%" --data-urlencode "echo_request=0" --data-urlencode "template_id=%TemplateId%" --data-urlencode "output_format=%TypeReport%" --data-urlencode "report_title=%Proyecto%"  "https://qualysapi.qualys.com/api/2.0/fo/report/" | "%~dp0xml.exe" sel -t -v "/SIMPLE_RETURN/RESPONSE/ITEM_LIST/ITEM/VALUE" > "%TEMP%\qualys_scan_report_id_%Timestamp%.txt" 2>NUL
ping -n 11 127.0.0.1 > NUL
set /P ID=<"%TEMP%\qualys_scan_report_id_%Timestamp%.txt"

if not defined ID (
echo "Error en la generacion del reporte. Revise las IP." && pause && del /F "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt" && del /F "%TEMP%\qualys_scan_report_id_%Timestamp%.txt" && exit
)

set state=Submitted

:while1
if /I %state% == Finished ( 
echo Descargando... && ping -n 21 127.0.0.1 > NUL && "%~dp0curl.exe" -s --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt" "https://qualysapi.qualys.com/api/2.0/fo/report/?action=fetch&id=%ID%" -o %Documentacion% && echo %Documentacion% && start "" /WAIT /I ""%Documentacion%"" 
) else ( 
echo . && ping -n 21 127.0.0.1 > NUL && "%~dp0curl.exe" -s --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt" -d "action=list&id=%ID%" "https://qualysapi.qualys.com/api/2.0/fo/report/" | "%~dp0xml.exe" sel -t -v "/REPORT_LIST_OUTPUT/RESPONSE/REPORT_LIST/REPORT/STATUS/STATE" > "%TEMP%\qualys_scan_report_state_%Timestamp%.txt" 2>NUL && set /p state=< "%TEMP%\qualys_scan_report_state_%Timestamp%.txt" && goto :while1 
)

"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt" -d "action=logout" "https://qualysapi.qualys.com/api/2.0/fo/session/" >NUL

del /F "%TEMP%\qualys_scan_report_auth_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_report_login_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_report_id_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_report_state_%Timestamp%.txt"

pause
