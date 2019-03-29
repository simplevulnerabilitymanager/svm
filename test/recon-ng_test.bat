setlocal
set Proyecto="test"
set Domains=www.example.com
set Documentacion="c:\svm\Reportes\test\"
set Timestamp=09_01_2019-19_21_20
set Server=192.168.139.153
set Username=root
set Password=toor

call recon_ng_remote.bat %Proyecto% %Domains% %Documentacion% %Timestamp% %Server% %Username% %Password%
