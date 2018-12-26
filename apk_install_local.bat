@echo off
setlocal
set PathAPK=%1
set FileAPK=%2
set Timestamp=%3
set Documentacion=%4


set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\apk_install - %Timestamp%.txt"

@title=[ADB]

rem date /T > %Documentacion%
rem time /T >> %Documentacion%
echo Kill-server
"%~dp0adb\windows\adb.exe" kill-server 
rem >> %Documentacion%
echo Start-server
"%~dp0adb\windows\adb.exe" start-server 
rem >> %Documentacion%
echo Installing...
"%~dp0adb\windows\adb.exe" install %PathAPK% 
rem >> %Documentacion%
echo Done
rem notepad %Documentacion%
pause

