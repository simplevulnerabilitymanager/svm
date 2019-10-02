@echo off
setlocal
set Tool=%1
set UsoProxy=%2
set ProxyIP=%3
set ProxyPort=%4
set ProxyUser=%5
set ProxyPassword=%6

if %UsoProxy% EQU 1 ( set Proxy=--proxy %ProxyIP%:%ProxyPort% --proxy-anyauth --proxy-user %ProxyUser%:%ProxyPassword% )
if %UsoProxy% EQU 0 ( set Proxy= )

@title=[Tools Instalar/Actualizar (Local) - %Tool%]

if "%Tool%" == "Nmap" ( 
mkdir "%~dp0tools" 2>NUL
mkdir "%~dp0tools\nmap" 2>NUL
"%~dp0curl.exe" %Proxy% -o "%TEMP%\nmap-7.70-setup.exe" "https://nmap.org/dist/nmap-7.70-setup.exe"
echo "%~dp0tools\nmap\nmap-7.70-setup.exe"
start "" /WAIT /I ""%TEMP%\nmap-7.70-setup.exe""
)

if "%Tool%" == "GreenShot" ( 
start "" /WAIT /I ""http://getgreenshot.org/downloads/""
)

if "%Tool%" == "Enjarify" ( 
mkdir "%~dp0tools" 2>NUL
mkdir "%~dp0tools\enjarify" 2>NUL
"%~dp0curl.exe" %Proxy% -L -o "%~dp0\tools\enjarify\enjarify-1.0.3.zip" "https://github.com/google/enjarify/archive/1.0.3.zip"
echo "Unzip the file %~dp0tools\enjarify\enjarify-1.0.3.zip"
)

if "%Tool%" == "Apktool" ( 
mkdir "%~dp0tools" 2>NUL
mkdir "%~dp0tools\apktool" 2>NUL
"%~dp0curl.exe" %Proxy% -L -o "%~dp0\tools\apktool\apktool.jar" "https://bitbucket.org/iBotPeaches/apktool/downloads/apktool_2.4.0.jar"
echo "%~dp0tools\apktool\apktool.jar"
)

if "%Tool%" == "UberApkSigner" ( 
mkdir "%~dp0tools" 2>NUL
mkdir "%~dp0tools\uber-apk-signer" 2>NUL
"%~dp0curl.exe" %Proxy% -L -o "%~dp0\tools\uber-apk-signer\uber-apk-signer.jar" "https://github.com/patrickfav/uber-apk-signer/releases/download/v1.0.0/uber-apk-signer-1.0.0.jar"
echo "%~dp0tools\uber-apk-signer\uber-apk-signer.jar"
)

if "%Tool%" == "Jdgui" ( 
mkdir "%~dp0tools" 2>NUL
mkdir "%~dp0tools\jdgui" 2>NUL
"%~dp0curl.exe" %Proxy% -L -o "%~dp0\tools\jdgui\jd-gui.jar" "https://github.com/java-decompiler/jd-gui/releases/download/v1.5.2/jd-gui-1.5.2.jar"
"%~dp0curl.exe" %Proxy% -L -o "%~dp0\tools\jdgui\jd-gui-windows.zip" "https://github.com/java-decompiler/jd-gui/releases/download/v1.5.2/jd-gui-windows-1.5.2.zip"
echo "%~dp0tools\jdgui\jd-gui.jar"
echo "Unzip the file %~dp0tools\jdgui\jd-gui-windows.zip"
)

rem ADB Android
rem https://dl.google.com/android/repository/platform-tools-latest-windows.zip

pause
