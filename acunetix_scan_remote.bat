@echo off
set Server=%7
set Username=%8
set TempDirRemote=\Temp\

runas /env /netonly /user:%Username% "xcopy /Y \"%~dp0acunetix_scan.bat\" \"\\%Server%\c$\%TempDirRemote%""
runas /env /netonly /user:%Username% "PsExec.exe \\%Server% %Username% c:\%TempDirRemote%\acunetix_scan.bat %1 %2 %3 %4 %5 %6"
pause