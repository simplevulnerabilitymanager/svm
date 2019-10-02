@echo off
setlocal
set Proyecto=%1
set File=%2
set Documentacion=%3
set Timestamp=%4
set DirApp=%5
set Server=%6
set Username=%7
set Password=%8

set Proyecto=%Proyecto:"=%
set Documentacion=%Documentacion:"=%

@title=[EyeWitness] - %Proyecto%

rem git clone https://github.com/ChrisTruncer/EyeWitness
rem cd EyeWitness ; cd setup ; ./setup.sh

echo "Generando script..."
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%File%" %Server%:"/tmp/EyeWitnessReport_%Timestamp%.txt"
"%~dp0plink.exe" -no-antispoof -batch -ssh -P 22 -l %Username% -pw %Password% -C %Server% "mkdir /tmp/EyeWitnessReport_%Timestamp%/"
"%~dp0plink.exe" -no-antispoof -batch -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'cd '%DirApp%' ; chmod 755 EyeWitness.py ; ./EyeWitness.py -f /tmp/EyeWitnessReport_%Timestamp%.txt --web --timeout 20 --threads 10 --user-agent \"Mozilla/5.0 (Windows NT 6.1; WOW64) AppleWebKit/537.21 (KHTML, like Gecko) Chrome/41.0.2228.0 Safari/537.21\" --prepend-https --active-scan --resolve --no-prompt -d "/tmp/EyeWitnessReport_%Timestamp%/" ' > /tmp/EyeWitness-script_%Timestamp%.sh"

echo "Ejecutando..."
@echo on
"%~dp0plink.exe" -no-antispoof -batch -ssh -P 22 -l %Username% -pw %Password% -C %Server% "export TERM=xterm ; chmod 755 /tmp/EyeWitness-script_%Timestamp%.sh ; /tmp/EyeWitness-script_%Timestamp%.sh"

@echo off
echo "Generando Reporte..."
"%~dp0plink.exe" -no-antispoof -batch -ssh -P 22 -l %Username% -pw %Password% -C %Server% "cd /tmp/ ; tar -cvzf 'EyeWitnessReport_%Timestamp%.tar.gz' 'EyeWitnessReport_%Timestamp%'"

"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/EyeWitnessReport_%Timestamp%.tar.gz" "%Documentacion%\EyeWitnessReport_%Timestamp%.tar.gz"

"%~dp0plink.exe" -no-antispoof -batch -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -fr '/tmp/EyeWitnessReport_%Timestamp%.tar.gz' ; rm -fr '/tmp/EyeWitnessReport_%Timestamp%'"

echo "%Documentacion%\EyeWitness_%Timestamp%.tar.gz"

pause