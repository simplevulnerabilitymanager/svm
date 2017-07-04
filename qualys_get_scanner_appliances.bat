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

@title=[Qualys] - Obteniendo "Scanner Appliances"

if %UsoProxy% EQU 1 ( set Proxy=--proxy %ProxyIP%:%ProxyPort% --proxy-anyauth --proxy-user %ProxyUser%:%ProxyPassword% )
if %UsoProxy% EQU 0 ( set Proxy= )

rem Login
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl SVM" -D "%TEMP%\qualys_get_scanner_appliances_auth_%Timestamp%.txt" --data "action=login" --data-urlencode "username=%Username%" --data-urlencode "password=%Password%" "https://qualysapi.qualys.com/api/2.0/fo/session/" -o "%TEMP%\qualys_get_scanner_appliances_login_%Timestamp%.txt" 2> NUL
findstr.exe /C:"Bad Login/Password" "%TEMP%\qualys_get_scanner_appliances_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Mal Usuario/Contraseña && pause && exit )

findstr.exe /C:"Service Unavailable" "%TEMP%\qualys_get_scanner_appliances_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Qualys Planned Maintenance && pause && exit )

rem Scanner Appliances
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl SVM" -b "%TEMP%\qualys_get_scanner_appliances_auth_%Timestamp%.txt" -G --data "action=list" "https://qualysapi.qualys.com/api/2.0/fo/appliance/" -o "%TEMP%\qualys_scanner_appliances_%Timestamp%.txt" 2> NUL
findstr.exe /C:"This API cannot be run again for another" "%TEMP%\qualys_scanner_appliances_%Timestamp%.txt"
if %ERRORLEVEL% EQU 0 ( echo La API no se puede usar por unas horas && pause && exit )

echo [Config] 1> "%TEMP%\qualys_scanner_appliances_%Timestamp%.ini"
type "%TEMP%\qualys_scanner_appliances_%Timestamp%.txt" | "%~dp0xml.exe" sel -T -t -m "/APPLIANCE_LIST_OUTPUT/RESPONSE/APPLIANCE_LIST/APPLIANCE" -o "ID" -v "position()"  -o "=" -v "ID" -n -o "Nombre" -v "position()"  -o "=\"" -v "NAME" -o "\"" -n -o "Ultimo=" -v "last()" -n 1>> "%TEMP%\qualys_scanner_appliances_%Timestamp%.ini" 2>NUL

rem Logout
"%~dp0curl.exe" -s %Proxy% --compressed -H "X-Requested-With: Curl SVM" -b "%TEMP%\qualys_get_scanner_appliances_auth_%Timestamp%.txt" --data "action=logout" "https://qualysapi.qualys.com/api/2.0/fo/session/" >NUL

del /F "%TEMP%\qualys_get_scanner_appliances_auth_%Timestamp%.txt"
del /F "%TEMP%\qualys_get_scanner_appliances_login_%Timestamp%.txt"
del /F "%TEMP%\qualys_scanner_appliances_%Timestamp%.txt"
