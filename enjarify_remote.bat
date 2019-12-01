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
set Documentacion="%Documentacion%\EnjarifyReport - %FileApk%_%Timestamp%.jar"

@title=[Enjarify] - %FileApk%

rem $git clone https://github.com/google/enjarify
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%PathAPK%" %Server%:"/tmp/%FileApk%_%Timestamp%.apk"
"%~dp0plink.exe" -no-antispoof -ssh -P 22 -l %Username% -pw %Password% -C %Server% "cd '%DirApp%' ; chmod 755 ./enjarify.sh  ; ./enjarify.sh -o '/tmp/EnjarifyReport - %FileApk%_%Timestamp%.jar' '/tmp/%FileApk%_%Timestamp%.apk'"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/EnjarifyReport - %FileApk%_%Timestamp%.jar" %Documentacion%
"%~dp0plink.exe" -no-antispoof -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/EnjarifyReport - %FileApk%_%Timestamp%.jar' '/tmp/%FileApk%_%Timestamp%.apk'"

echo %Documentacion%
pause

