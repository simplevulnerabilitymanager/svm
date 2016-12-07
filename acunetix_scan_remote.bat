@echo off
set Server=%7
set Username=%8
set TempDirRemote=\Temp\

echo Descargando PsExec de live.sysinternals.com...
rem Algunos antivirus lo detectan como Malware al psexec por eso no se incluye mas en el instalador.

"%~dp0curl.exe" -s -o psexec.exe https://live.sysinternals.com/psexec.exe
runas /env /netonly /user:%Username% "xcopy /Y \"%~dp0acunetix_scan.bat\" \"\\%Server%\c$\%TempDirRemote%""
runas /env /netonly /user:%Username% "psexec.exe \\%Server% %Username% c:\%TempDirRemote%\acunetix_scan.bat %1 %2 %3 %4 %5 %6"
pause