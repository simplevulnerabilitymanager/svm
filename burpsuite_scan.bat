@echo off
setlocal
set burpsuite=%1
set scheme=%2
set fqdn=%3
set port=%4
set folder=%5
set ext=%~x1

@title=[Burpsuite Scan ] - %scheme%://%fqdn%:%port%

echo Iniciando escaneo a %scheme%://%fqdn%:%port%

echo Burpsuite Pro con Carbonator
echo https://www.integrissecurity.com/index.php?resources=Carbonator

if "%ext%" == ".jar" (
rem java -jar -Xmx2g %burpsuite% -Djava.awt.headless=true %scheme% %fqdn% %port% /%folder%
java -jar -Xmx2g %burpsuite% %scheme% %fqdn% %port% %folder%
)

if "%ext%" == ".exe" (
%burpsuite% %scheme% %fqdn% %port% %folder%
)

pause