@echo off
set File=%1

@title=[Upload File To Android Device]

"%~dp0adb\windows\adb.exe" kill-server
"%~dp0adb\windows\adb.exe" wait-for-device
rem "%~dp0adb\windows\adb.exe" start-server
"%~dp0adb\windows\adb.exe" push %File% /sdcard/Download/

echo.
echo "copied to /sdcard/Download/"
echo.
pause

