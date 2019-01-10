setlocal
set Proyecto="test"
set URL=https://www.example.com
set APIURL=https://127.0.0.1:3443
set APIKEY=1986ad8c0a5b3df4d7028d5f3c06e936c79703c3056b94a74bc4a286ee76c6103
set Documentacion="c:\svm\Reportes\test\"
set Timestamp=09_01_2019-19_21_20
set NRO=1

call acunetix_v11_scan.bat %Proyecto% %URL% %APIURL% %APIKEY% %Documentacion% %Timestamp% %NRO%