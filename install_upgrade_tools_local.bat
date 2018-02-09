@echo off
setlocal
set Tool=%1

@title=[Tools Instalar/Actualizar (Local) - %Tool%]

if "%Tool%" == "Nmap" ( 
"%~dp0curl.exe" -o "%TEMP%\nmap-7.60-setup.exe" "https://nmap.org/dist/nmap-7.60-setup.exe"
start "" /WAIT /I ""%TEMP%\nmap-7.60-setup.exe""
)

if "%Tool%" == "GreenShot" ( 
start "" /WAIT /I ""http://getgreenshot.org/downloads/""
)

pause
