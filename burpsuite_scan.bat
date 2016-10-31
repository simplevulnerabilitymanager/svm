@echo off
set burpsuite=%1
set scheme=%2
set fqdn=%3
set port=%4
set folder=%5

rem Burpsuite Pro con Carbonator
rem https://www.integrissecurity.com/index.php?resources=Carbonator
@title=[Burpsuite Scan ] - %scheme%://%fqdn%:%port%

echo Iniciando escaneo a %scheme%://%fqdn%:%port%
rem java -jar -Xmx2g %burpsuite% -Djava.awt.headless=true %scheme% %fqdn% %port% /%folder%
java -jar -Xmx2g %burpsuite% %scheme% %fqdn% %port% %folder%

pause