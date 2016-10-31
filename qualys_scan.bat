@echo off
set Proyecto=%1
set ProyectoDoc=%1
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
set TemplateId=%8
set Timestamp=%9

@title=[Qualys Scan] - %Proyecto%

set Proyecto=%Proyecto: =+%
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



if %Appliance% == External ( 
set URL="https://qualysapi.qualys.com/msp/scan.php?scan_title=%Proyecto%&ip=%IP%&option=%Policy%&save_report=yes" 
) else ( 
set URL="https://qualysapi.qualys.com/msp/scan.php?scan_title=%Proyecto%&ip=%IP%&iscanner_name=%Appliance%&option=%Policy%&save_report=yes" 
)
:while1
echo Escaneando...
"%~dp0curl.exe" --compressed -H "X-Requested-With: Curl Sample" -u %Username%:%Password% %URL% 1> "%TEMP%\qualys_login_%Timestamp%.txt"
findstr.exe /C:"Service Unavailable" "%TEMP%\qualys_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo Qualys Planned Maintenance && pause && exit)
findstr.exe /C:"Cannot launch scan. These IPs are not in your subscription:" "%TEMP%\qualys_login_%Timestamp%.txt" > NUL
if %ERRORLEVEL% EQU 0 ( echo La ip no esta en Qualys. Agregando... && "%~dp0curl.exe" -s --compressed -H "X-Requested-With: Curl Sample" -u %Username%:%Password% "https://qualysapi.qualys.com/msp/asset_ip.php?action=add&host_ips=%IP%&tracking_method=ip&owner=%Username%&comment=%Proyecto%" > NUL && echo Agregado && ping -n 61 127.0.0.1 > NUL && goto while1 )

if not %AutoReport% == 0 ( echo Generando reporte automaticamente && ping -n 61 127.0.0.1 > NUL && call "%~dp0qualys_report.bat" %ProyectoDoc% %IP% %Username% %Password% %Documentacion% %TypeReport% %TemplateId% %Timestamp% )

del /F "%TEMP%\qualys_login_%Timestamp%.txt"