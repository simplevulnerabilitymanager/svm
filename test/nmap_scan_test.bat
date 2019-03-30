setlocal
set Proyecto="test"
set IP="127.0.0.1"
set Timestamp=30_03_2019-00_11_56
set Documentacion="c:\svm_test\Reportes\test\"
set AppExe="c:\Program Files (x86)\Nmap\nmap.exe"



copy "%WORKSPACE%\nmap_scan.bat" c:\svm_test\
cd c:\svm_test\
mkdir Reportes
mkdir Reportes\test\
call nmap_scan.bat %Proyecto% %IP% %Timestamp% %Documentacion% %AppExe%
