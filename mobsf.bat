@echo off
setlocal
set PathAPK=%1
set FileApk=%2
set Timestamp=%3
set Documentacion=%4
set Server=%5

set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\MobSFReport - %FileApk%_%Timestamp%.pdf"

@title=[MobSF] - %FileApk%

rem $git clone https://github.com/ajinabraham/Mobile-Security-Framework-MobSF
rem Levantarlo:
rem (windows) c:\python27\python.exe c:\MobSF\manage.py runserver 0.0.0.0:8000
rem (linux) python ./manage.py runserver 0.0.0.0:8000

"%~dp0curl.exe" -s -k "%Server%"
if %ERRORLEVEL% NEQ 0 ( echo MobSF no iniciado. Inicie sesion por SSH a %Server% y ejecute python /root/Mobile-Security-Framework-MobSF/manage.py runserver %Server%:8000 && pause && exit )

rem Peticion 1
"%~dp0curl.exe" -k -H "Referer: %Server%" -D "%TEMP%\mobsf_auth_%Timestamp%.txt" "%Server%" > "%TEMP%\mobsf_token_1_%Timestamp%.txt"
findstr /C:"X-CSRFToken" "%TEMP%\mobsf_token_1_%Timestamp%.txt" > "%TEMP%\mobsf_token_2_%Timestamp%.txt"
set /p TOKEN=<"%TEMP%\mobsf_token_2_%Timestamp%.txt"
FOR /F "tokens=1-2" %%A IN ("%TOKEN%") DO set TOKEN=%%B
set TOKEN=%TOKEN:'=%
set TOKEN=%TOKEN:)=%
set TOKEN=%TOKEN:;=%

rem Peticion 2
"%~dp0curl.exe" -k -X POST -b "%TEMP%\mobsf_auth_%Timestamp%.txt" -H "X-CSRFToken: %TOKEN%" -H "Referer: %Server%" -F file="@%PathAPK%" "%Server%/Upload/" | "%~dp0jq-win32.exe" .url > "%TEMP%\mobsf_json_%Timestamp%.txt"
set /p requestId=<"%TEMP%\mobsf_json_%Timestamp%.txt"

for /f "tokens=1,2,3 delims=:&" %%a in (%requestId%) do set getchecksum=%%c
for /f "tokens=1,2 delims=:=" %%a in ("%getchecksum%") do set checksum=%%b

rem Peticion 3
"%~dp0curl.exe" -k -b "%TEMP%\mobsf_auth_%Timestamp%.txt" -H "Referer: %Server%" "%Server%/StaticAnalyzer/?name=%FileApk%&type=apk&checksum=%checksum%" > NUL

rem Peticion 4
"%~dp0curl.exe" -k -b "%TEMP%\mobsf_auth_%Timestamp%.txt" -H "Referer: %Server%/StaticAnalyzer/?name=%FileApk%&type=apk&checksum=%checksum%" "%Server%/PDF/?md5=%checksum%&type=APK" -o %Documentacion%

del /F "%TEMP%\mobsf_auth_%Timestamp%.txt"
del /F "%TEMP%\mobsf_token_1_%Timestamp%.txt"
del /F "%TEMP%\mobsf_token_2_%Timestamp%.txt"
del /F "%TEMP%\mobsf_json_%Timestamp%.txt"

echo %Documentacion%
start "" /WAIT /I ""%Documentacion%""

pause
