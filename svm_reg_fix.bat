set PARAM=/i
rem /i Registrar librerias
rem /u Un-Registrar librerias
if EXIST %windir%\system32\vbRichClient5.dll (
	%windir%\system32\regsvr32.exe %PARAM% %windir%\system32\vbRichClient5.dll
)

if EXIST %windir%\SysWOW64\vbRichClient5.dll (
%windir%\system32\regsvr32.exe %PARAM% %windir%\SysWOW64\vbRichClient5.dll
)

if EXIST "%~dp0vbRichClient5.dll" (
%windir%\system32\regsvr32.exe %PARAM% "%~dp0vbRichClient5.dll"
)

if EXIST "%~dp0VBCCR16.OCX" (
%windir%\system32\regsvr32.exe %PARAM% "%~dp0VBCCR16.OCX"
)

if EXIST %windir%\System32\msstdfmt.dll (
%windir%\system32\regsvr32.exe %PARAM% %windir%\System32\msstdfmt.dll
)

if EXIST %windir%\SysWOW64\msstdfmt.dll (
%windir%\system32\regsvr32.exe %PARAM% %windir%\SysWOW64\msstdfmt.dll
)

if EXIST "%~dp0msstdfmt.dll" (
%windir%\system32\regsvr32.exe %PARAM% "%~dp0msstdfmt.dll"
)
