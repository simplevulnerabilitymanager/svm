set PARAM=/i
rem /i Registrar librerias
rem /u Des-Registrar librerias
if EXIST "%~dp0vbRichClient5.dll" (
%windir%\system32\regsvr32.exe %PARAM% "%~dp0vbRichClient5.dll"
)