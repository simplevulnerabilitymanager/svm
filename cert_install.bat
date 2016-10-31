@echo off
set File=%1
set Timestamp=%3

rem https://www.sslshopper.com/ssl-converter.html
rem Convert PEM/Base64 to DER/Binary
rem openssl x509 -outform der -in certificate.pem -out certificate.der

rem Convert DER/Binary to PEM/Base64
rem openssl x509 -inform der -in certificate.der -out certificate.pem


@title=[ADB-Install Certificate]

"%~dp0adb\windows\adb.exe" kill-server
"%~dp0adb\windows\adb.exe" start-server
"%~dp0adb\windows\adb.exe" push %File% /sdcard/
echo "Once your phone is on, go to Settings -> Security -> Install from SD card."
echo "Follow the on screen instructions, and reboot the device once it says the certificate has been installed."
pause

