@echo off
setlocal
set AppExe=%1
set PathAPK=%2
rem Generar el certificado
rem del /f keystore.ks
rem "c:\Program Files\Java\jre1.8.0_161\bin\keytool.exe" -genkey -keystore keystore.ks -alias android -keyalg RSA -keysize 2048 -validity 365 -dname "C=US, O=Android, CN=Android Debug"

rem Firmar el apk
rem "c:\Program Files\Java\jdk1.8.0_101\bin\jarsigner.exe" -verbose -sigalg MD5withRSA -digestalg SHA1 -keystore keystore.ks %PathAPK% android
rem $ java -Xmx256m -jar C:/Users/u544786/.apkstudio/vendor/uber-apk-signer.jar --debug -ks "c:/pentest/Android/keystore.ks" --ksPass Ulises2k --ksKeyPass Ulises2k -a "c:/pentest/Android/Android_test.apk" --ksAlias android --overwrite --allowResign
rem "c:\android\sdk\build-tools\21.1.2\zipalign.exe" -c -v 4 %PathAPK%

java.exe -jar %AppExe% -a %PathAPK% --overwrite
echo %PathAPK%
pause
