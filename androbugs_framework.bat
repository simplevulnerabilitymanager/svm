@echo off
setlocal
set PathAPK=%1
set FileApk=%2
set Timestamp=%3
set Documentacion=%4
set DirApp=%5
set Server=%6
set Username=%7
set Password=%8


set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set DirApp=%DirApp:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\AndroBugs_Framework - %FileApk%_%Timestamp%.txt"

@title=[AndroBugs_Framework] - %FileApk%

rem $git clone https://github.com/AndroBugs/AndroBugs_Framework
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "mkdir '/tmp/%Timestamp%'"
"%~dp0pscp.exe" -l %Username% -pw %Password% -C "%PathAPK%" %Server%:"/tmp/%Timestamp%/%FileApk%_%Timestamp%.apk"
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "cd '%DirApp%' ; python ./androbugs.py -f '/tmp/%Timestamp%/%FileApk%_%Timestamp%.apk' -e 2 -o '/tmp/%Timestamp%'"

"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/%Timestamp%/*.txt" %Documentacion%
"%~dp0plink.exe" -P 22 -ssh -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/%Timestamp%/'"

echo %Documentacion%
pause


