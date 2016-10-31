rem @echo off
set AndroidSDK=%1
set AVDName=%2
set Proxy=%3
set Port=%4

@title=[Android Emulator - %AVDName%]

set AndroidSDK=%AndroidSDK:"=%

echo Primero inicie el proxy(Burpsuite/OWASP ZAP) y luego presione una tecla para iniciar el emulador Android
pause
"%AndroidSDK%\tools\emulator.exe" -avd %AVDName% -http-proxy %Proxy%:%Port% -debug-proxy
pause

