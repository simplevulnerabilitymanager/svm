@echo off
setlocal
set WebSVM=%1
set Username=%2
set Password=%3
set WebID=%4
set Proyecto=%5
set Vulnerabilidades=%6
set Solucionadas=%7
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
@title=[WebSVM] - %Proyecto%
echo WebSVM - Actualizando Cantidad Vulnerabilidades encontradas...

rem Login
"%~dp0curl.exe" -s -k --compressed -D "%TEMP%\web_vulnerabilidades_auth_%Timestamp%.txt" --data "username=%Username%" --data "password=%Password%" "%WebSVM%/login.php" >NUL

rem Proyectos Vulnerabilidades
"%~dp0curl.exe" -s -k --compressed -b "%TEMP%\web_vulnerabilidades_auth_%Timestamp%.txt" --data "webid=%WebID%" --data "vulnerabilidades=%Vulnerabilidades%" --data "solucionadas=%Solucionadas%" "%WebSVM%/proyectos_vulnerabilidades.php" -o "%TEMP%\web_vulnerabilidades_vulnerabilidades_%Timestamp%.txt"

rem Logout
"%~dp0curl.exe" -s -k --compressed -b "%TEMP%\web_vulnerabilidades_auth_%Timestamp%.txt" "%WebSVM%/login.php?logout" >NUL

del /F "%TEMP%\web_vulnerabilidades_auth_%Timestamp%.txt"
del /F "%TEMP%\web_vulnerabilidades_vulnerabilidades_%Timestamp%.txt"
