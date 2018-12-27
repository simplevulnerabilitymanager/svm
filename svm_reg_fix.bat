set PARAM=/i
rem /i Registrar librerias
rem /u Un-Registrar librerias
if EXIST "%~dp0vbRichClient5.dll" (
%windir%\system32\regsvr32.exe %PARAM% "%~dp0vbRichClient5.dll"
)

if EXIST "%~dp0VBCCR16.OCX" (
%windir%\system32\regsvr32.exe %PARAM% "%~dp0VBCCR16.OCX"
)
