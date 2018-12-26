@echo off
setlocal
set AppExe=%1
set PathDirAPK=%2
set AppExeSign=%3

rem Editar segun corresponda al entorno
rem "c:\Program Files\Java\jre1.8.0_171\bin\java.exe"
set JAVA="java.exe"
set PathDirAPK=%PathDirAPK:"=%
if %PathDirAPK:~-1% == \ set PathDirAPK=%PathDirAPK:~0,-1%
for %%i in (%PathDirAPK%) do set LastDirAPK=%%~nxi

@title=[Apktool_Build - Local] - %PathDirAPK%

rem curl.exe https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.3.3.jar
%JAVA% -jar %AppExe% b "%PathDirAPK%"

set PathDirAPK=%PathDirAPK:"=%
echo "%PathDirAPK%\dist\%LastDirAPK%.apk"

:retry
echo Want to sign the apk?
set /p respuesta="Yes/No(y/n)"
if %respuesta% == y (
call apk_sign_local.bat %AppExeSign% "%PathDirAPK%\dist\%LastDirAPK%.apk"
) else (
if %respuesta% == n (
goto :fin
) else (
goto :retry
)
)
:fin

