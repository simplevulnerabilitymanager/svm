@echo off
setlocal
set Proyecto=%1
set IP=%2
set Username=%3
set Password=%4
set Appliance=%5
set Policy=%6
set AutoReport=%7
set Documentacion=%8
set TypeReport=%9
shift
shift
shift
shift
shift
shift
shift
set TemplateId=%3
set Timestamp=%4
set UsoProxy=%5
set ProxyIP=%6
set ProxyPort=%7
set ProxyUser=%8
set ProxyPassword=%9

set Proyecto=%Proyecto:"=%
set IP=%IP:"=%

@title=[Qualys Scan] - %Proyecto%

if %UsoProxy% EQU 1 ( set Proxy=--proxy %ProxyIP%:%ProxyPort% --proxy-anyauth --proxy-user %ProxyUser%:%ProxyPassword% )
if %UsoProxy% EQU 0 ( set Proxy= )


rem Login
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -D "%TEMP%\qualys_scan_auth_%Timestamp%.txt" --data "action=login" --data-urlencode "username=%Username%" --data-urlencode "password=%Password%" "https://qualysapi.qualys.com/api/2.0/fo/session/" -o "%TEMP%\qualys_scan_login_%Timestamp%.txt" 2> NUL
findstr.exe /C:"Bad Login/Password" "%TEMP%\qualys_scan_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Mal Usuario/Contraseña && pause && exit )

findstr.exe /C:"Service Unavailable" "%TEMP%\qualys_scan_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Qualys Planned Maintenance && pause && exit )


rem Launch a Scan
cls

echo Escaneando...
:while1
if %Appliance% == External (
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_auth_%Timestamp%.txt" --data "action=launch" --data-urlencode "ip=%IP%" --data-urlencode "echo_request=0" --data-urlencode "scan_title=%Proyecto%" --data-urlencode "option_title=%Policy%" "https://qualysapi.qualys.com/api/2.0/fo/scan/" -o "%TEMP%\qualys_scan_launch_%Timestamp%.txt" 2> NUL
) else (
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_auth_%Timestamp%.txt" --data "action=launch" --data-urlencode "ip=%IP%" --data-urlencode "echo_request=0" --data-urlencode "scan_title=%Proyecto%" --data-urlencode "iscanner_name=%Appliance%" --data-urlencode "option_title=%Policy%" "https://qualysapi.qualys.com/api/2.0/fo/scan/" -o "%TEMP%\qualys_scan_launch_%Timestamp%.txt" 2> NUL
)
findstr.exe /C:"This API cannot be run again for another" "%TEMP%\qualys_scan_launch_%Timestamp%.txt"
if %ERRORLEVEL% EQU 0 ( echo La API no se puede usar por unas horas && pause && exit )

type "%TEMP%\qualys_scan_launch_%Timestamp%.txt" | "%~dp0xml.exe" sel -t -v "/SIMPLE_RETURN/RESPONSE/ITEM_LIST/ITEM/VALUE" 2>NUL | find "scan/" > "%TEMP%\qualys_scan_id_%Timestamp%.txt" 2>NUL

ping -n 11 127.0.0.1 > NUL
set /P ID=<"%TEMP%\qualys_scan_id_%Timestamp%.txt"

if not defined ID (
echo La ip no esta en Qualys. Agregando... && "%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -u %Username%:%Password% -G --data "action=add" --data-urlencode "host_ips=%IP%" --data-urlencode "tracking_method=ip" --data-urlencode "owner=%Username%" --data-urlencode "comment=%Proyecto%" "https://qualysapi.qualys.com/msp/asset_ip.php" > NUL 2> NUL && echo Agregado && ping -n 11 127.0.0.1 > NUL && goto while1
)

rem Details Scans
:while2
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_auth_%Timestamp%.txt" --data "action=list" --data-urlencode "scan_ref=%ID%" "https://qualysapi.qualys.com/api/2.0/fo/scan/" | "%~dp0xml.exe" sel -t -v "/SCAN_LIST_OUTPUT/RESPONSE/SCAN_LIST/SCAN/STATUS/STATE" > "%TEMP%\qualys_scan_status_%Timestamp%.txt" 2>NUL
set /p STATUS=< "%TEMP%\qualys_scan_status_%Timestamp%.txt"
if /I %STATUS% == Finished ( echo: ) else ( ping -n 61 127.0.0.1 > NUL && time /T && goto :while2 )

rem Logout
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_scan_auth_%Timestamp%.txt" --data "action=logout" "https://qualysapi.qualys.com/api/2.0/fo/session/" >NUL


rem Export Scan
call "%~dp0qualys_scan_report.bat" "%Proyecto%" "%IP%" %Username% %Password% %Documentacion% %TypeReport% 1275603 %Timestamp% %UsoProxy% %ProxyIP% %ProxyPort% %ProxyUser% %ProxyPassword%

if %AutoReport% EQU 1 ( call "%~dp0qualys_report.bat" "%Proyecto%" "%IP%" %Username% %Password% %Documentacion% %TypeReport% %TemplateId% %Timestamp% %UsoProxy% %ProxyIP% %ProxyPort% %ProxyUser% %ProxyPassword% )

del /F "%TEMP%\qualys_scan_auth_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_login_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_id_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_launch_%Timestamp%.txt"
del /F "%TEMP%\qualys_scan_status_%Timestamp%.txt"

pause