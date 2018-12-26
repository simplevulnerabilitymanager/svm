@echo off
setlocal
set PathAPK=%1
set FileAPK=%2
set Timestamp=%3
set Documentacion=%4
set Server=%5
set Port=%6


set Documentacion=%Documentacion:"=%
set Documentacion="%Documentacion%\apk_install_remoto - %Timestamp%.txt"

@title=[ADB-Remoto]

echo Connectando...
"%~dp0adb\windows\adb.exe" connect %Server%:%Port%
echo Installing...
"%~dp0adb\windows\adb.exe" install %PathAPK%

pause





