@echo off
set PathAPK=%1
set FileApk=%2
set Timestamp=%3
set Documentacion=%4
set Server=%5
set Username=%6
set Password=%7
set DirApp=/root/enjarify/
set FileApp=enjarify.sh

set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\EnjarifyReport - %FileApk%_%Timestamp%.jar"

@title=[Enjarify] - %FileApk%

rem $git clone https://github.com/google/enjarify
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%PathAPK%" %Server%:"/tmp/%FileApk%_%Timestamp%.apk"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "cd %DirApp% ; ./%FileApp% -o '/tmp/EnjarifyReport - %FileApk%_%Timestamp%.jar' '/tmp/%FileApk%_%Timestamp%.apk'"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/EnjarifyReport - %FileApk%_%Timestamp%.jar" %Documentacion%
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/EnjarifyReport - %FileApk%_%Timestamp%.jar' '/tmp/%FileApk%_%Timestamp%.apk'"

echo %Documentacion%
pause

