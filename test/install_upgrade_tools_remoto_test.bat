set Server=192.168.139.153
set Username=root
set Password=toor
set Tool=Todas


mkdir Reportes
mkdir Reportes\test\
copy "%WORKSPACE%\install_upgrade_tools_remoto.bat" c:\svm_test\
cd c:\svm_test\
mkdir Reportes
mkdir Reportes\test\
echo y | plink.exe -ssh -P 22 -l %Username% -pw %Password% -C %Server% 'ls'
call install_upgrade_tools_remoto.bat %Server% %Username% %Password% %Tool%