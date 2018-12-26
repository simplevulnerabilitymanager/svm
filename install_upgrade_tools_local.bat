@echo off
setlocal
set Tool=%1

@title=[Tools Instalar/Actualizar (Local) - %Tool%]

if "%Tool%" == "Nmap" ( 
mkdir "%~dp0\tools" >NUL
mkdir "%~dp0\tools\nmap" >NUL
"%~dp0curl.exe" -o "%TEMP%\nmap-7.70-setup.exe" "https://nmap.org/dist/nmap-7.70-setup.exe"
echo "%~dp0\tools\nmap\nmap-7.70-setup.exe"
start "" /WAIT /I ""%TEMP%\nmap-7.70-setup.exe""
)

if "%Tool%" == "GreenShot" ( 
start "" /WAIT /I ""http://getgreenshot.org/downloads/""
)

if "%Tool%" == "Enjarify" ( 
mkdir "%~dp0\tools" >NUL
mkdir "%~dp0\tools\enjarify" >NUL
"%~dp0curl.exe" -L -o "%~dp0\tools\enjarify\enjarify-1.0.3.zip" "https://github.com/google/enjarify/archive/1.0.3.zip"
echo "%~dp0\tools\enjarify\enjarify-1.0.3.zip"
)

if "%Tool%" == "Apktool" ( 
mkdir "%~dp0\tools" >NUL
mkdir "%~dp0\tools\apktool" >NUL
"%~dp0curl.exe" -L -o "%~dp0\tools\apktool\apktool.jar" "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.3.3.jar"
echo "%~dp0\tools\apktool\apktool.jar"
)

if "%Tool%" == "UberApkSigner" ( 
mkdir "%~dp0\tools" >NUL
mkdir "%~dp0\tools\uber-apk-signer" >NUL
"%~dp0curl.exe" -L -o "%~dp0\tools\uber-apk-signer\uber-apk-signer.jar" "https://github.com/patrickfav/uber-apk-signer/releases/download/v0.8.4/uber-apk-signer-0.8.4.jar"
echo "%~dp0\tools\uber-apk-signer\uber-apk-signer.jar"
)

if "%Tool%" == "Jdgui" ( 
mkdir "%~dp0\tools" >NUL
mkdir "%~dp0\tools\jdgui" >NUL
"%~dp0curl.exe" -L -o "%~dp0\tools\jdgui\jd-gui.jar" "https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui-1.4.0.jar"
"%~dp0curl.exe" -L -o "%~dp0\tools\jdgui\jd-gui-windows-1.4.0.zip" "https://github.com/java-decompiler/jd-gui/releases/download/v1.4.0/jd-gui-windows-1.4.0.zip"
echo "%~dp0\tools\jdgui\jd-gui.jar"
echo "%~dp0\tools\jdgui\jd-gui-windows-1.4.0.zip"
)

#ADB Android
#https://dl.google.com/android/repository/platform-tools-latest-windows.zip

pause
