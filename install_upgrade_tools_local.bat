@echo off
setlocal
set Tool=%1

@title=[Tools Instalar/Actualizar (Local) - %Tool%]

if "%Tool%" == "Psexec" ( 
"%~dp0curl.exe" -o psexec.exe "https://live.sysinternals.com/psexec.exe"
)

if "%Tool%" == "Nmap" ( 
"%~dp0curl.exe" -o "%TEMP%\nmap-7.50-setup.exe" "https://nmap.org/dist/nmap-7.50-setup.exe"
start "" /WAIT /I ""%TEMP%\nmap-7.50-setup.exe""
)

if "%Tool%" == "GreenShot" ( 
start "" /WAIT /I ""http://getgreenshot.org/downloads/""
)

pause
