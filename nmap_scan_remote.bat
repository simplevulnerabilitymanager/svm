@echo off
setlocal
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
set Timestamp=%Timestamp:"=%
set DocumentacionXML=NmapReport - %Timestamp%.xml
set DocumentacionHTML=NmapReport - %Timestamp%.html

@title=[Nmap Scan (Remote)] - %Proyecto%
rem apt-get install nmap
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo %IP% | nmap -Pn -O --system-dns -vv -sS -sC -sV -oX '/tmp/%DocumentacionXML%' -pT:1-65535,U:7,9,13,17,19,21,37,53,67-69,98,111,121,123,135,137-138,161,177,371,389,407,445,456,464,500,512,514,517-518,520,555,635,666,858,1001,1010-1011,1015,1024-1049,1051-1055,1170,1194,1243,1245,1434,1492,1600,1604,1645,1701,1807,1812,1900,1978,1981,1999,2001-2002,2023,2049,2115,2140,2801,2967,3024,3129,3150,3283,3527,3700,3801,4000,4092,4156,4569,4590,4781,5000-5001,5036,5060,5321,5400-5402,5503,5569,5632,5742,6051,6073,6502,6670,6771,6912,6969,7000,7111,7222,7300-7301,7306-7308,7778,7789,7938,9872-9875,9989,10067,10167,11000,11223,12223,12345-12346,12361-12362,15253,15345,16969,17185,20001,20034,21544,21862,22222,23456,26274,26409,27444,30029,31335,31337-31339,31666,31785,31789,31791-31792,32771,33333,34324,40412,40421-40423,40426,47262,50505,50766,51100-51101,51109,53001,54321,61466 --webxml -iL - "
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/%DocumentacionXML%" "%TEMP%\%DocumentacionXML%"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/%DocumentacionXML%" "%Documentacion%\%DocumentacionXML%"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/%DocumentacionXML%'"
"%~dp0xml.exe" tr "%~dp0nmap.xsl" "%TEMP%\%DocumentacionXML%" > "%Documentacion%\%DocumentacionHTML%"

del /F "%TEMP%\%DocumentacionXML%"

echo "%Documentacion%\%DocumentacionHTML%"
start "" /WAIT /I """%Documentacion%\%DocumentacionHTML%"""

pause
