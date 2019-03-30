setlocal
set Proyecto="test"
set Domains=www.example.com
set Documentacion="c:\svm_test\Reportes\test\"
set Timestamp=09_01_2019-19_21_20
set Server=192.168.139.153
set Username=root
set Password=toor

copy %WORKSPACE%\recon_ng_remote.bat c:\svm_test\
cd c:\svm_test\
mkdir Reportes
mkdir Reportes\test\
echo y | plink.exe -ssh -P 22 -l %Username% -pw %Password% -C %Server% 'ls'
call recon_ng_remote.bat %Proyecto% %Domains% %Documentacion% %Timestamp% %Server% %Username% %Password%
