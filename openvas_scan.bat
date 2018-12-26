@echo off
setlocal
set Proyecto=%1
set IP=%2
set Server=%3
set Port=%4
set Username=%5
set Password=%6
set ScanConfig=%7
set FormatID=%8
set Documentacion=%9
shift
set Timestamp=%9
set IP=%IP:"=%
set Proyecto=%Proyecto:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\OpenvasReport - %Timestamp%.html"

@title=[OpenVAS Scan] - %Proyecto%


rem http://docs.greenbone.net/API/OMP/omp.html#command_create_target
"%~dp0omp_cracked.exe" --host=%Server% --port=%Port% --username=%Username% --password=%Password% --xml="<create_target><name>\"%Proyecto%_%Timestamp%\"</name><hosts>%IP%</hosts><alive_tests>Consider Alive</alive_tests><port_range>T:1-65535,U:7,9,13,17,19,21,37,53,67-69,98,111,121,123,135,137-138,161,177,371,389,407,445,456,464,500,512,514,517-518,520,555,635,666,858,1001,1010-1011,1015,1024-1049,1051-1055,1170,1194,1243,1245,1434,1492,1600,1604,1645,1701,1807,1812,1900,1978,1981,1999,2001-2002,2023,2049,2115,2140,2801,2967,3024,3129,3150,3283,3527,3700,3801,4000,4092,4156,4569,4590,4781,5000-5001,5036,5060,5321,5400-5402,5503,5569,5632,5742,6051,6073,6502,6670,6771,6912,6969,7000,7111,7222,7300-7301,7306-7308,7778,7789,7938,9872-9875,9989,10067,10167,11000,11223,12223,12345-12346,12361-12362,15253,15345,16969,17185,20001,20034,21544,21862,22222,23456,26274,26409,27444,30029,31335,31337-31339,31666,31785,31789,31791-31792,32771,33333,34324,40412,40421-40423,40426,47262,50505,50766,51100-51101,51109,53001,54321,61466</port_range></create_target>" 1> "%TEMP%\openvas_scan_target_%Timestamp%.txt"
findstr.exe /C:"OK" "%TEMP%\openvas_scan_target_%Timestamp%.txt"
if %ERRORLEVEL% NEQ 0 ( echo ---Error. Revise Usuario/Contraseña o levante el servicio en %Server% ejecutando: && echo service openvas-scanner restart && echo service openvas-manager restart && echo service greenbone-security-assistant restart && pause && exit )
type "%TEMP%\openvas_scan_target_%Timestamp%.txt" | "%~dp0xml.exe" sel -t -m "create_target_response" -v "@id" > %TEMP%\openvas_scan_target_id_%Timestamp%.txt"
set /p target_id=<"%TEMP%\openvas_scan_target_id_%Timestamp%.txt"


rem http://docs.greenbone.net/API/OMP/omp.html#command_create_task
"%~dp0omp_cracked.exe" --host=%Server% --port=%Port% --username=%Username% --password=%Password% --xml="<create_task><name>\"%Proyecto%_%Timestamp%\"</name><config id=\"%ScanConfig%\"></config><target id=\"%target_id%\"></target></create_task>" 1> "%TEMP%\openvas_scan_task_%Timestamp%.txt"
findstr.exe /C:"Failed to find target" "%TEMP%\openvas_scan_task_%Timestamp%.txt"
if %ERRORLEVEL% EQU 0 ( echo Failed to find target && pause && exit )
findstr.exe /C:"OK" "%TEMP%\openvas_scan_task_%Timestamp%.txt"
if %ERRORLEVEL% NEQ 0 ( echo ---Error(1)--- && pause && exit )
type "%TEMP%\openvas_scan_task_%Timestamp%.txt" | "%~dp0xml.exe" sel -t -m "create_task_response" -v "@id" > %TEMP%\openvas_scan_task_id_%Timestamp%.txt"
if %ERRORLEVEL% NEQ 0 ( echo ---Error(2)--- && pause && exit )
set /p task_id=<"%TEMP%\openvas_scan_task_id_%Timestamp%.txt"


rem http://docs.greenbone.net/API/OMP/omp.html#command_start_task
"%~dp0omp_cracked.exe" --host=%Server% --port=%Port% --username=%Username% --password=%Password% --xml="<start_task task_id=\"%task_id%\"></start_task>" 1> "%TEMP%\openvas_scan_report_%Timestamp%.txt"
findstr.exe /C:"OK" "%TEMP%\openvas_scan_report_%Timestamp%.txt"
if %ERRORLEVEL% NEQ 0 ( echo ---Error(3)--- && pause && exit )
type "%TEMP%\openvas_scan_report_%Timestamp%.txt" | "%~dp0xml.exe" sel -t -v "start_task_response/report_id" > %TEMP%\openvas_scan_report_id_%Timestamp%.txt"
set /p report_id=<"%TEMP%\openvas_scan_report_id_%Timestamp%.txt"

cls
echo Escaneando...
:scan1
rem http://docs.greenbone.net/API/OMP/omp.html#command_get_tasks
"%~dp0omp_cracked.exe" --host=%Server% --port=%Port% --username=%Username% --password=%Password% --xml="<get_tasks task_id=\"%task_id%\"></get_tasks>" 1> "%TEMP%\openvas_scan_status_report_%Timestamp%.txt"
type "%TEMP%\openvas_scan_status_report_%Timestamp%.txt" | "%~dp0xml.exe" sel -t -v "get_tasks_response/task/status"  > "%TEMP%\openvas_scan_status_scan_%Timestamp%.txt"
findstr.exe /C:"Internal Error" "%TEMP%\openvas_scan_status_scan_%Timestamp%.txt"
if %ERRORLEVEL% EQU 0 ( echo "Internal Error" && pause && exit )
findstr.exe /C:"Stopped" "%TEMP%\openvas_scan_status_scan_%Timestamp%.txt"
if %ERRORLEVEL% EQU 0 ( echo Stopped && pause && exit )
findstr.exe /C:"Done" "%TEMP%\openvas_scan_status_scan_%Timestamp%.txt"
if %ERRORLEVEL% EQU 0 ( echo: ) else ( ping -n 61 127.0.0.1 > NUL && time /T && goto :scan1 )

echo Generando Reporte...
rem http://docs.greenbone.net/API/OMP/omp.html#command_get_reports
"%~dp0omp_cracked.exe" --host=%Server% --port=%Port% --username=%Username% --password=%Password% --xml="<get_reports report_id=\"%report_id%\" filter=\"autofp=0 apply_overrides=1 notes=1 overrides=1 result_hosts_only=1 sort-reverse=severity levels=hml min_qod=70\" format_id=\"%FormatID%\"/>" 1> "%TEMP%\openvas_scan_report_response_%Timestamp%.txt"
type "%TEMP%\openvas_scan_report_response_%Timestamp%.txt" | "%~dp0xml.exe" sel -t -v "get_reports_response/report/text()" > "%TEMP%\openvas_scan_b64_report_%Timestamp%.txt"
"%~dp0openssl.exe" -in "%TEMP%\openvas_scan_b64_report_%Timestamp%.txt" enc -base64 -d -out %Documentacion%

del /F "%TEMP%\openvas_scan_target_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_target_id_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_task_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_task_id_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_report_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_report_id_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_status_scan_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_status_report_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_report_response_%Timestamp%.txt"
del /F "%TEMP%\openvas_scan_b64_report_%Timestamp%.txt"

echo %Documentacion%
start "" /WAIT /I ""%Documentacion%""

pause
