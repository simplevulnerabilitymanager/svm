@echo off
set Proyecto=%1
set URL=%2
set Documentacion=%3
set Timestamp=%4
set NRO=%5
set Server=%6
set Username=%7
set Password=%8

rem #################################################################################
rem #Editar valores segun corresponda a la web
rem
rem Habilitar esto cuando tenga HTTP Authentication
rem set http-username=Admin
rem set http-password=Password
rem --http-authentication-username=%http-username% --http-authentication-password=%http-password%

set scope-exclude-pattern=Logout

rem set plataform=linux,mysql,apache,php
set plataform=windows,sql,iis,aspx
rem arachni --platforms-list


rem Plugin: login_script
rem --plugin=login_script:script=/tmp/Login.txt
rem
rem Guardar esto en un archivo, llamado Login.txt y configurar los parametros
rem With browser (slow)
rem gem install watir-webdriver
rem gem install selenium-webdriver
rem ......................
rem -------------Login.txt-----------------------------------------------
rem browser.goto 'http://testphp.acunetix.com/login.php'
rem form = browser.form( id: 'loginform' )
rem form.text_field( name: 'uname' ).set 'test'
rem form.text_field( name: 'pass' ).set 'test'
rem form.submit
rem framework.options.session.check_url     = browser.url
rem framework.options.session.check_pattern = /Logout/
rem -------------Login.txt-----------------------------------------------
rem
rem Without browser (fast)
rem ......................
rem Guardar esto en un script y luego pasarlo como parametros al plugin
rem -------------Login.txt-----------------------------------------------
rem response = http.post( 'http://testphp.acunetix.com/login.php',
rem     parameters:     {
rem         'uname'   => 'test',
rem         'pass' => 'test'
rem     },
rem     mode:           :sync,
rem     update_cookies: true
rem )
rem framework.options.session.check_url     = to_absolute( response.headers.location, response.url )
rem framework.options.session.check_pattern = /Logout|Sign out|Cerrar Sesion/
rem -------------Login.txt-----------------------------------------------


rem Plugin: autologin
rem set LoginPage=%URL%/login.php
rem --plugin=autologin:url=%LoginPage%,parameters='uname=test&pass=test',check='Logout|Sign out|Cerrar Sesion'
rem #################################################################################


set User-Agent=Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/49.0.2623.112 Safari/537.36

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
set User-Agent=%User-Agent:"=%
set User-Agent=%User-Agent:'=%


copy "%~dp0Login_fast.rb" "%Documentacion%Login_fast.rb"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C "%Documentacion%Login_fast.rb" %Server%:"/tmp/Login"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "chmod 755 /tmp/Login"

echo Escaneando...
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "arachni --output-verbose --output-only-positives  --http-user-agent='%User-Agent%' --audit-links --audit-forms --audit-cookies --audit-headers --audit-jsons --audit-xmls --audit-ui-inputs --audit-ui-forms --checks=*   --plugin=login_script:script=/tmp/Login    --scope-exclude-pattern=%scope-exclude-pattern% --platforms=%plataform%  --report-save-path='/tmp/ArachniReport - %Proyecto% - %Timestamp%.afr' %URL%"

echo Generando Reporte...
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "arachni_reporter '/tmp/ArachniReport - %Proyecto% - %Timestamp%.afr' --reporter=html:outfile='/tmp/ArachniReport - %Proyecto% - %Timestamp%.zip'"
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/ArachniReport - %Proyecto% - %Timestamp%.zip" "%Documentacion%\ArachniReport - %Proyecto% - %Timestamp%.zip"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -fr '/tmp/Login' '/tmp/ArachniReport - %Proyecto% - %Timestamp%.zip' '/tmp/ArachniReport - %Proyecto% - %Timestamp%.afr'"

echo "%Documentacion%\ArachniReport - %Proyecto% - %Timestamp%.zip"
pause
