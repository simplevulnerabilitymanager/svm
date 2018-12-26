@echo off
setlocal
set AppExe=%1
set PathAPK=%2
rem Expands %~n3 to a file name only
set FileApk=%~n3
set Timestamp=%4
set Documentacion=%5

rem Editar segun corresponda al entorno
set JAVA="java.exe"

set FileApk=%FileApk:"=%
set Documentacion=%Documentacion:"=%

@title=[Apktool - Local] - %FileApk%

rem curl.exe https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.3.3.jar

rem mkdir "%Documentacion%\%FileApk%_%Timestamp%"
rem cd "%Documentacion%\%FileApk%_%Timestamp%"
copy %PathAPK% "%Documentacion%\%FileApk%_%Timestamp%.apk"
%JAVA% -jar %AppExe% d "%Documentacion%\%FileApk%_%Timestamp%.apk" -o "%Documentacion%\%FileApk%_%Timestamp%"
echo "%Documentacion%\%FileApk%_%Timestamp%"
pause



