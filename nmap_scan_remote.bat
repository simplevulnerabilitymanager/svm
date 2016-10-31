@echo off
set Proyecto=%1
set IP=%2
set Timestamp=%3
set Documentacion=%4
set Server=%5
set Username=%6
set Password=%7

set IP=%IP:"=%
set IP=%IP:,= %
set Documentacion=%Documentacion:"=%
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
set Timestamp=%Timestamp:"=%
set DocumentacionXML=NmapReport - %Proyecto% - %Timestamp%.xml
set DocumentacionHTML=NmapReport - %Proyecto% - %Timestamp%.html

@title=[Nmap Scan] - %Proyecto%
rem apt-get install nmap
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo %IP% | nmap -vv -sS -sC -sV -oX '/tmp/%DocumentacionXML%' -pT:1-65535 --webxml -iL - "
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/%DocumentacionXML%" "%TEMP%\%DocumentacionXML%"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/%DocumentacionXML%" "%Documentacion%\%DocumentacionXML%"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/%DocumentacionXML%'"
"%~dp0xml.exe" tr "%~dp0nmap.xsl" "%TEMP%\%DocumentacionXML%" > "%Documentacion%\%DocumentacionHTML%"

del /F "%TEMP%\%DocumentacionXML%"

echo "%Documentacion%\%DocumentacionHTML%"
start "" /WAIT /I """%Documentacion%\%DocumentacionHTML%"""

pause
