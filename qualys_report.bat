@echo off
set Proyecto=%1
set IP=%2
set Username=%3
set Password=%4
set Documentacion=%5
set TypeReport=%6
set TemplateId=%7
set Timestamp=%8

@title=[Qualys Report] - %Proyecto%

set Proyecto=%Proyecto: =+%
set Proyecto=%Proyecto:&=_%
set Proyecto=%Proyecto:(=_%
set Proyecto=%Proyecto:)=_%

set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\QualysReport - %Timestamp%.%TypeReport%"

echo Generando Reporte...
"%~dp0curl.exe" -s -g --compressed -H "X-Requested-With: Curl Sample" -D "%TEMP%\qualys_report_auth_%Timestamp%.txt" -d "action=login&username=%Username%&password=%Password%" "https://qualysapi.qualys.com/api/2.0/fo/session/" >NUL
"%~dp0curl.exe" -s -g --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_report_auth_%Timestamp%.txt" -d "action=launch&ips=%IP%&echo_request=0&template_id=%TemplateId%&report_title=%Proyecto%&output_format=%TypeReport%" "https://qualysapi.qualys.com/api/2.0/fo/report/" | "%~dp0xml.exe" sel -t -v "/SIMPLE_RETURN/RESPONSE/ITEM_LIST/ITEM/VALUE" > "%TEMP%\qualys_report_id_%Timestamp%.txt" 2>NUL
ping -n 11 127.0.0.1 > NUL
set /P ID=<"%TEMP%\qualys_report_id_%Timestamp%.txt"
set state=Submitted


:while1
if /I %state% == Finished ( 
echo Descargando... && ping -n 11 127.0.0.1 > NUL && "%~dp0curl.exe" -s -g --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_report_auth_%Timestamp%.txt" "https://qualysapi.qualys.com/api/2.0/fo/report/?action=fetch&id=%ID%" -o %Documentacion% 
) else ( 
echo . && "%~dp0curl.exe" -s -g --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_report_auth_%Timestamp%.txt" -d "action=list&id=%ID%" "https://qualysapi.qualys.com/api/2.0/fo/report/" | "%~dp0xml.exe" sel -t -v "/REPORT_LIST_OUTPUT/RESPONSE/REPORT_LIST/REPORT/STATUS/STATE" > "%TEMP%\qualys_report_state_%Timestamp%.txt" 2>NUL && set /p state=< "%TEMP%\qualys_report_state_%Timestamp%.txt" && goto :while1 
)

"%~dp0curl.exe" -s -g --compressed -H "X-Requested-With: Curl Sample" -b "%TEMP%\qualys_report_auth_%Timestamp%.txt" -d "action=logout" "https://qualysapi.qualys.com/api/2.0/fo/session/" >NUL

del /F "%TEMP%\qualys_report_auth_%Timestamp%.txt"
del /F "%TEMP%\qualys_report_id_%Timestamp%.txt"
del /F "%TEMP%\qualys_report_state_%Timestamp%.txt"


if %TypeReport% == xml ( 
type %Documentacion% | "%~dp0xml.exe" sel -t -m "ASSET_DATA_REPORT/GLOSSARY/VULN_DETAILS_LIST/VULN_DETAILS" -v "QID[@id]" -o " - " -v "TITLE" -n 2>NUL | more && type %Documentacion% | "%~dp0xml.exe" sel -t -m "ASSET_DATA_REPORT/HOST_LIST/HOST" -n -v "IP" -m "VULN_INFO_LIST/VULN_INFO" -n -o "  QID:" -v "QID[@id]" -n -o "  Resultado:" -n -v "RESULT" -n -n 2>NUL | more
) else ( 
echo %Documentacion% && start "" /WAIT /I ""%Documentacion%""
)

pause
