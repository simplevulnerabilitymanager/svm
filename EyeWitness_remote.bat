@echo off
set Proyecto=%1
set File=%2
set Documentacion=%3
set Timestamp=%4
set Server=%5
set Username=%6
set Password=%7



set Proyecto=%Proyecto:"=%
set Proyecto=%Proyecto:^^~=%
set Proyecto=%Proyecto:^^&=%
set Proyecto=%Proyecto:^*=%
set Proyecto=%Proyecto::=%
set Proyecto=%Proyecto:^<=%
set Proyecto=%Proyecto:^>=%
set Proyecto=%Proyecto:?=%
set Proyecto=%Proyecto:^|=%
set Proyecto=%Proyecto:^==%
set Proyecto=%Proyecto:$=%
set Proyecto=%Proyecto:^^=%
set Documentacion=%Documentacion:"=%

@title=[EyeWitness] - %Proyecto%

rem git clone https://github.com/ChrisTruncer/EyeWitness
rem cd setup ; ./setup.sh

echo "Generando script..."
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%File%" %Server%:"/tmp/EyeWitness_%Timestamp%.txt"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'cd ; cd EyeWitness ; chmod 755 EyeWitness.py ; ./EyeWitness.py -f /tmp/EyeWitness_%Timestamp%.txt --headless --timeout 20 --threads 10  --prepend-https --active-scan --resolve --no-prompt -d "/tmp/%Proyecto%_%Timestamp%/" ' > /tmp/EyeWitness-script_%Timestamp%.sh"

echo "Ejecutando..."
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "export TERM=xterm ; chmod 755 /tmp/EyeWitness-script_%Timestamp%.sh ; /tmp/EyeWitness-script_%Timestamp%.sh"

echo "Generando Reporte..."
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "cd /tmp/ ; tar -cvzf '%Proyecto%_%Timestamp%.tar.gz' '%Proyecto%_%Timestamp%'"

"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/%Proyecto%_%Timestamp%.tar.gz" "%Documentacion%"

echo "%Documentacion%\%Proyecto%_%Timestamp%.tar.gz"

pause