@echo off
setlocal
set DirApp=%1
set PathAPK=%2
set FileApk=%3
set Timestamp=%4
set Documentacion=%5
set Server=%6
set Username=%7
set Password=%8

set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set DirApp=%DirApp:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\QarkReport - %FileApk%_%Timestamp%.tar.gz"

@title=[Qark] - %FileApk%

rem $git clone https://github.com/linkedin/qark
"%~dp0pscp.exe" -l %Username% -pw %Password% -C "%PathAPK%" %Server%:"/tmp/%FileApk%_%Timestamp%.apk"
"%~dp0pscp.exe" -l %Username% -pw %Password% -C "%~dp0qark.sh" %Server%:"/tmp/qark.sh"
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "tr -d '\15\32' < /tmp/qark.sh > '%DirApp%/qark.sh'"
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/qark.sh'"

:retry
cls
echo Ejecutar en el server %Server% el comando:
echo cd "%DirApp%" ; chmod 755 qark.sh ; ./qark.sh "%DirApp%" "%FileApk%_%Timestamp%"
echo Solo cuando termine, presione una tecla para obtener el reporte
set /p respuesta="Desea continuar? (y/n)"
pause

if %respuesta% == y (

rem "%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "export TERM=xterm ; cd '%DirApp%' ; chmod 755 ./qark.sh ; ./qark.sh '%DirApp%' '%FileApk%_%Timestamp%'"

"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "cd '%DirApp%/qark' ; tar -cvzf '/tmp/QarkReport - %FileApk%_%Timestamp%.tar.gz' '/tmp/%FileApk%_%Timestamp%.apk' 'Report_%FileApk%_%Timestamp%/' logs/ exploit/"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/QarkReport - %FileApk%_%Timestamp%.tar.gz" %Documentacion%
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/QarkReport - %FileApk%_%Timestamp%.tar.gz' '%DirApp%/qark.sh'"

echo %Documentacion%
pause
) else (
if %respuesta% == n (
goto :fin
) else (
goto :retry
)
)

:fin