@echo off
setlocal
set WebSVM=%1
set Username=%2
set Password=%3
set Timestamp=%4
set UsoProxy=%5
set ProxyIP=%6
set ProxyPort=%7
set ProxyUser=%8
set ProxyPassword=%9

if %UsoProxy% EQU 1 ( set Proxy=--proxy %ProxyIP%:%ProxyPort% --proxy-anyauth --proxy-user %ProxyUser%:%ProxyPassword% )
if %UsoProxy% EQU 0 ( set Proxy= )

echo Descargando Proyectos ...
rem Login
"%~dp0curl.exe" -s %Proxy% --compressed --insecure -D "%TEMP%\web_proyectos_auth_%Timestamp%.txt" --data-urlencode "username=%Username%" --data-urlencode "password=%Password%" "%WebSVM%/login.php" >NUL 2>NUL

rem Proyectos
"%~dp0curl.exe" -s %Proxy% --compressed --insecure -b "%TEMP%\web_proyectos_auth_%Timestamp%.txt" -o "%TEMP%\proyectos_%Timestamp%.ini" "%WebSVM%/proyectos_exportar.php"

rem Logout
"%~dp0curl.exe" -s %Proxy% --compressed --insecure -b "%TEMP%\web_proyectos_auth_%Timestamp%.txt" "%WebSVM%/login.php?logout" >NUL

del /F "%TEMP%\web_proyectos_auth_%Timestamp%.txt"
