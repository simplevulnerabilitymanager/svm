
c:\svm_test\curl -o "C:\svm_test\Reportes\test\MaterialLoginExample.apk" "https://raw.githubusercontent.com/katalon-studio-samples/Material-Login-App-Test/master/App%20Files/MaterialLoginExample.apk"

set DirApp="/root/enjarify/"
set PathAPK="C:\svm_test\Reportes\test\MaterialLoginExample.apk"
set FileApk="MaterialLoginExample.apk"
set Timestamp=30_03_2019-00_40_38
set Documentacion="C:\svm\Reportes\test\"
set Server=192.168.139.153
set Username=root
set Password=toor

mkdir Reportes
mkdir Reportes\test\
copy "%WORKSPACE%\enjarify_remote.bat" c:\svm_test\
cd c:\svm_test\
mkdir Reportes
mkdir Reportes\test\
echo y | plink.exe -ssh -P 22 -l %Username% -pw %Password% -C %Server% 'ls'
call enjarify_remote.bat %DirApp% %PathAPK% %FileApk% %Timestamp% %Documentacion% %Server% %Username% %Password%
