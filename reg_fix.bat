if EXIST %windir%\system32\vbRichClient5.dll (
%windir%\system32\regsvr32.exe %windir%\system32\vbRichClient5.dll
)

if EXIST %windir%\SysWOW64\vbRichClient5.dll (
%windir%\system32\regsvr32.exe %windir%\SysWOW64\vbRichClient5.dll
)

if EXIST "%~dp0vbRichClient5.dll" (
%windir%\system32\regsvr32.exe "%~dp0vbRichClient5.dll"
)

if EXIST "%~dp0VBCCR13.OCX" (
%windir%\system32\regsvr32.exe "%~dp0VBCCR13.OCX"
)

pause