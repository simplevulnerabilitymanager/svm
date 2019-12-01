@echo off
setlocal
set PathAPK=%1
set FileApk=%2
set Timestamp=%3
set Documentacion=%4
set AppExe=%5
set Server=%6
set Username=%7
set Password=%8

rem Editar segun corresponda al entorno
set JAVA=/usr/bin/java

set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set AppExe=%AppExe:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\ApktoolReport - %FileApk%_%Timestamp%.tar.gz"

@title=[Apktool] - %FileApk%

rem $wget https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.1.0.jar
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%PathAPK%" %Server%:"/tmp/%FileApk%_%Timestamp%.apk"
"%~dp0plink.exe" -no-antispoof -ssh -P 22 -l %Username% -pw %Password% -C %Server% "cd /tmp ; %JAVA% -jar '%AppExe%' d '/tmp/%FileApk%_%Timestamp%.apk'"
"%~dp0plink.exe" -no-antispoof -ssh -P 22 -l %Username% -pw %Password% -C %Server% "cd /tmp ; tar -cvzf 'ApktoolReport - %FileApk%_%Timestamp%.tar.gz' '%FileApk%_%Timestamp%.apk' '%FileApk%_%Timestamp%'"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/ApktoolReport - %FileApk%_%Timestamp%.tar.gz" %Documentacion%
"%~dp0plink.exe" -no-antispoof -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -fr '/tmp/ApktoolReport - %FileApk%_%Timestamp%.tar.gz' '/tmp/%FileApk%_%Timestamp%.apk' /tmp/1.apk"

echo %Documentacion%
pause



