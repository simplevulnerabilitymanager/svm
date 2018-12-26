@echo off
setlocal
set AppExe=%1
set PathAPK=%2
rem Expands %~n2 to a file name only
set FileApk=%~n2
set Timestamp=%3
set Documentacion=%4

set PathAPK=%PathAPK:"=%
set FileApk=%FileApk:"=%
set DirApp=%DirApp:"=%
set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\%FileApk%_%Timestamp%.jar"

@title=[Enjarify] - %PathAPK%

rem $git clone https://github.com/google/enjarify

%AppExe% -o "%Documentacion%" "%PathAPK%"

echo %Documentacion%
pause

