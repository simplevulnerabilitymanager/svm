@echo off
setlocal
rem https://www.youtube.com/watch?v=p2gpjTZgOa0 - OSINT - recon-ng information gathering example tutorial
set Proyecto=%1
set Domains=%2
set Documentacion=%3
set Timestamp=%4
set Server=%5
set Username=%6
set Password=%7

rem MODIFY WITH YOUR APIs
set google_api=
set github_api=
set hashes_api=
set shodan_api=
set pwnedlist_api=
set pwnedlist_secret=
set pwnedlist_iv=
set fullcontact_api=
set virustotal_api=
set twitter_api=
set twitter_secret=
set bing_api=
set builtwith_api=
set flickr_api=
set jigsaw_username=
set jigsaw_password=
set jigsaw_api=
set ipstack_api=
set ipinfodb_api=
set censysio_id=
set censysio_secret=
rem MODIFY WITH YOUR APIs

set Documentacion=%Documentacion:"=%
set DocumentacionReport="%Documentacion%\recon-ngReport - %Timestamp%.html"
set DocumentacionNetworks="%Documentacion%\recon-ngReport-Networks - %Timestamp%.txt"
set DocumentacionSubdomains="%Documentacion%\recon-ngReport-Subdomains - %Timestamp%.txt"
set DocumentacionIP="%Documentacion%\recon-ngReport-IP - %Timestamp%.txt"

@title=[Recon-ng] - %Proyecto%

rem git clone https://bitbucket.org/LaNMaSteR53/recon-ng.git
rem pip install -r REQUIREMENTS
rem Otros modulos para Recon-ng
rem https://github.com/scumsec/Recon-ng-modules
rem http://10degres.net/subdomain-enumeration/ mas tools
echo "Generando script..."
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'workspaces add %Proyecto%' > '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'add companies %Proyecto%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'workspaces select %Proyecto%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

set Domains=%Domains:"=%
for %%a in (%Domains:,= %) do (
	"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'add domains %%a' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
)
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'load recon/domains-hosts/netcraft' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add bing_api %bing_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add builtwith_api %builtwith_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add fullcontact_api %fullcontact_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add github_api %github_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add google_api %google_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add google_cse %google_cse%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add hashes_api %hashes_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add shodan_api %shodan_api%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/bing_domain_api' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/bing_domain_web' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/builtwith' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/brute_hosts' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/ssl_san' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/vpnhunter' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/certificate_transparency' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/google_site_web' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/hackertarget' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/mx_spf_ip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/shodan_hostname' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/threatcrowd' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"


echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-hosts/reverse_resolve' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-hosts/shodan_net' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-companies/whois_orgs' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-ports/census_2012' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-ports/censysio' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/ports-hosts/migrate_ports' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/reverse_resolve' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/resolve' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/bing_ip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/freegeoip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/ipinfodb' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/ssltools' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-ports/shodan_ip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'back' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool start /tmp/recon-ngreport-networks - %Timestamp%.txt' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'query SELECT netblock FROM netblocks ORDER BY netblock' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool stop' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool start /tmp/recon-ngreport-ip - %Timestamp%.txt' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'query SELECT DISTINCT ip_address FROM hosts WHERE ip_address IS NOT NULL ORDER BY host' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool stop' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool start /tmp/recon-ngreport-subdomains - %Timestamp%.txt' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'query SELECT DISTINCT host,ip_address FROM hosts WHERE ip_address IS NOT NULL ORDER BY host' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool stop' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

echo .
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'load reporting/html' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set CREATOR SVM' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set CUSTOMER %Proyecto%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set FILENAME /tmp/recon-ngReport - %Timestamp%.html' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set SANITIZE True' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'exit' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

echo "Ejecutando..."
rem "%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "/root/recon-ng/recon-ng -r '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "which recon-ng ; if [ $? -ne 0 ] ; then /root/recon-ng/recon-ng -r '/tmp/recon-ng-script_%Timestamp%.txt' ; else recon-ng -r '/tmp/recon-ng-script_%Timestamp%.txt' ; fi"

echo "Generando Reporte..."
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "unix2dos '/tmp/recon-ngreport-networks - %Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "unix2dos '/tmp/recon-ngreport-subdomains - %Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "unix2dos '/tmp/recon-ngreport-ip - %Timestamp%.txt'"

"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngReport - %Timestamp%.html" %DocumentacionReport%
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngreport-networks - %Timestamp%.txt" %DocumentacionNetworks%
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngreport-subdomains - %Timestamp%.txt" %DocumentacionSubdomains%
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngreport-ip - %Timestamp%.txt" %DocumentacionIP%


"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngReport - %Timestamp%.html'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngreport-networks - %Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngreport-subdomains - %Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngreport-ip - %Timestamp%.txt'"
"%~dp0plink.exe" -no-antispoof -P 22 -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ng-script_%Timestamp%.txt'"


echo %DocumentacionReport%
echo %DocumentacionNetworks%
echo %DocumentacionSubdomains%
echo %DocumentacionIP%

pause