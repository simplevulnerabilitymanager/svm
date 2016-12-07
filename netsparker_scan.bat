@echo off
set Proyecto=%1
set Netsparker=%2
set URL=%3
set Documentacion=%4
set Timestamp=%5
set NRO=%6

set Proyecto=%Proyecto:"=%


set Documentacion=%Documentacion:"=%

@title=[Netsparker Scan] - %Proyecto%

set /a SLEEP=%NRO%*20
ping -n %SLEEP% 127.0.0.1 > NUL

cls
echo Escaneando...
echo Nombre Profile a usar: %Proyecto%

:while1
tasklist /FI "IMAGENAME eq Netsparker.exe" /NH | find /C "Netsparker.exe" > "%TEMP%\netsparker_scan_count_%Timestamp%-URL_%NRO%.txt"
set /p CANT=<"%TEMP%\netsparker_scan_count_%Timestamp%-URL_%NRO%.txt"
set DocumentacionHTML="%Documentacion%\NetsparkerReport - %Timestamp%-URL_%NRO%.html"
if %CANT% GEQ 2 ( ping -n 61 127.0.0.1 > NUL && goto :while1 ) else ( %Netsparker% /auto /profile "%Proyecto%" /url %URL% /report %DocumentacionHTML% )

echo Finalizado
del /F "%TEMP%\netsparker_scan_count_%Timestamp%-URL_%NRO%.txt"

pause


