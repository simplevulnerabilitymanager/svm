@echo off
set Username=%1
set Password=%2
set Timestamp=%3

@title=[Qualys Report] - Obteniendo Listado de Reportes

"%~dp0curl.exe" -s -k --compressed -H "X-Requested-With: Curl Sample" --user %Username%:%Password% "https://qualysapi.qualys.com/msp/report_template_list.php" | "%~dp0xml.exe" fo  > "%TEMP%\qualys_report_list_%Timestamp%.txt" 2>NUL

notepad.exe "%TEMP%\qualys_report_list_%Timestamp%.txt"

del /F "%TEMP%\qualys_report_auth_%Timestamp%.txt"


