@echo off
setlocal
set Proyecto=%1
set DirApp=%2
set URL=%3
set Documentacion=%4
set Timestamp=%5
set NRO=%6


set Documentacion=%Documentacion:"=%
set DirApp=%DirApp:"=%

set Proyecto=%Proyecto:"=%
@title=[Acunetix Scan] - %Proyecto%

set /a SLEEP=%NRO%*20
ping -n %SLEEP% 127.0.0.1 > NUL


echo Escaneando...
rem Acunetix v6.0 - 10.50
set Doc1="%Documentacion%\AcunetixReport - %TimeStamp%-URL_%NRO%\"
set Login="%Documentacion%\..\Login.lsr"
:whileAcu1
if exist "%DirApp%\wvs_console.exe" ( 
tasklist /FI "IMAGENAME eq wvs_console.exe" /NH | find /C "wvs_console.exe" > "%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"
set /p CANT=<"%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"
goto Acunetix1
)


rem Acunetix v11.0
set Doc2="%Documentacion%\AcunetixReport - %TimeStamp%-URL_%NRO%.wvs"
set Login="%Documentacion%\Login.lsr"
:whileAcu2
if exist "%DirApp%\wvsc.exe" (
tasklist /FI "IMAGENAME eq wvsc.exe" /NH | find /C "wvsc.exe" > "%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"
set /p CANT=<"%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"
goto Acunetix2
)


:Acunetix1
if %CANT% GEQ 5 ( 
ping -n 61 127.0.0.1 > NUL && goto whileAcu1 
) else ( 
mkdir %Doc1% 
"%DirApp%\wvs_console.exe" /Scan %URL% /Profile Default /Settings default /LoginSeq %Login% /Save /SaveFolder %Doc1% /SavetoDatabase /GenerateReporte /ReporteFormat PDF /Timestamps /Verbose --GetFirstOnly=FALSE --RobotsTxt=TRUE --UseWebKit=TRUE --EnablePortScanning=TRUE --UseAcuSensor=TRUE 
)
goto Fin



:Acunetix2
pause
if %CANT% GEQ 5 ( 
ping -n 61 127.0.0.1 > NUL && goto whileAcu2 
) else ( 
"%DirApp%\wvsc.exe" /scan %URL% /profile Default /status /login-sequence %Login% /allow-interactive-login /save %Doc2% 
)
goto Fin


:Fin
echo Finalizado
del /F "%TEMP%\acunetix_scan_count_%Timestamp%-URL_%NRO%.txt"

pause
