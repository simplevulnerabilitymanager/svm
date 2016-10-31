@echo off
set Proyecto=%1
set Acunetix=%2
set URL=%3
set Documentacion=%4
set Timestamp=%5
set NRO=%6


set Documentacion=%Documentacion:"=%
set Login="%Documentacion%\..\Login.lsr"

set Proyecto=%Proyecto:"=%
set Proyecto=%Proyecto:^^~=%
set Proyecto=%Proyecto:^^&=%
set Proyecto=%Proyecto:^*=%
set Proyecto=%Proyecto::=%
set Proyecto=%Proyecto:^<=%
set Proyecto=%Proyecto:^>=%
set Proyecto=%Proyecto:?=%
set Proyecto=%Proyecto:^|=%
set Proyecto=%Proyecto:^==%
set Proyecto=%Proyecto:$=%
set Proyecto=%Proyecto:^^=%

@title=[Acunetix Scan] - %Proyecto%
set /a SLEEP=%NRO%*20
ping -n %SLEEP% 127.0.0.1 > NUL

set Documentacion="%Documentacion%\AcunetixReport - %Proyecto% - %TimeStamp%-URL_%NRO%\"


cls
echo Escaneando...
:while1
tasklist /FI "IMAGENAME eq wvs_console.exe" /NH | find /C "wvs_console.exe" > "%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"
set /p CANT=<"%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"
if %CANT% GEQ 5 ( ping -n 61 127.0.0.1 > NUL && goto :while1 ) else ( mkdir %Documentacion% && %Acunetix% /Scan %URL% /Profile Default /Settings default /LoginSeq %Login% /Save /SaveFolder %Documentacion% /SavetoDatabase /GenerateReporte /ReporteFormat PDF /Timestamps /Verbose --GetFirstOnly=FALSE --RobotsTxt=TRUE --UseWebKit=TRUE --EnablePortScanning=TRUE --UseAcuSensor=TRUE )

echo Finalizado
del /F "%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"

pause


