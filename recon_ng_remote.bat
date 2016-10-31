@echo off
rem https://www.youtube.com/watch?v=p2gpjTZgOa0
set Proyecto=%1
set Domains=%2
set Documentacion=%3
set Timestamp=%4
set Server=%5
set Username=%6
set Password=%7


set Documentacion=%Documentacion:"=%
set DocumentacionReport="%Documentacion%\recon-ngReport - %Timestamp%.html"
set DocumentacionNetworks="%Documentacion%\recon-ngReport-Networks - %Timestamp%.txt"
set DocumentacionSubdomains="%Documentacion%\recon-ngReport-Subdomains - %Timestamp%.txt"
set DocumentacionIP="%Documentacion%\recon-ngReport-IP - %Timestamp%.txt"

@title=[Recon-ng] - %Proyecto%

rem git clone https://LaNMaSteR53@bitbucket.org/LaNMaSteR53/recon-ng.git
rem pip install -r REQUIREMENTS
echo "Generando script..."
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'workspaces add %Proyecto%' > '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'add companies %Proyecto%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'workspaces select %Proyecto%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

set Domains=%Domains:"=%
for %%a in (%Domains:,= %) do (
	"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'add domains %%a' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
)

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'load recon/domains-hosts/netcraft' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem "%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'keys add bing_api <value>' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
rem keys add bing_api <value>
rem keys add builtwith_api <value>
rem keys add fullcontact_api <value>
rem keys add github_api <value>
rem keys add google_api <value>
rem keys add google_cse <value>
rem keys add hashes_api <value>
rem keys add shodan_api <value>
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/bing_domain_api' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/bing_domain_web' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/builtwith' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/brute_hosts' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/ssl_san' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/domains-hosts/vpnhunter' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"


"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-hosts/reverse_resolve' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/reverse_resolve' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/resolve' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-companies/whois_orgs' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-hosts/shodan_net' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-ports/census_2012' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/netblocks-ports/censysio' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/ports-hosts/migrate_ports' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/bing_ip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/freegeoip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/ipinfodb' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-hosts/ssltools' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'use recon/hosts-ports/shodan_ip' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'back' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool start /tmp/recon-ngreport-networks - %Timestamp%.txt' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'query SELECT netblock FROM netblocks ORDER BY netblock' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool stop' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool start /tmp/recon-ngreport-ip - %Timestamp%.txt' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'query SELECT DISTINCT ip_address FROM hosts WHERE ip_address IS NOT NULL ORDER BY host' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool stop' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool start /tmp/recon-ngreport-subdomains - %Timestamp%.txt' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'query SELECT DISTINCT host,ip_address FROM hosts WHERE ip_address IS NOT NULL ORDER BY host' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'spool stop' >> '/tmp/recon-ng-script_%Timestamp%.txt'"

"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'load reporting/html' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set CREATOR Ulises' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set CUSTOMER %Proyecto%' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set FILENAME  /tmp/recon-ngReport - %Timestamp%.html' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'set SANITIZE True' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'run' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "echo 'exit' >> '/tmp/recon-ng-script_%Timestamp%.txt'"
echo "Ejecutando..."
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "recon-ng -r '/tmp/recon-ng-script_%Timestamp%.txt'"
echo "Generando Reporte..."
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "unix2dos '/tmp/recon-ngreport-networks - %Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "unix2dos '/tmp/recon-ngreport-subdomains - %Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "unix2dos '/tmp/recon-ngreport-ip - %Timestamp%.txt'"

"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngReport - %Timestamp%.html" %DocumentacionReport%
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngreport-networks - %Timestamp%.txt" %DocumentacionNetworks%
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngreport-subdomains - %Timestamp%.txt" %DocumentacionSubdomains%
"%~dp0pscp.exe" -P 22 -l %Username% -pw %Password% -C %Server%:"/tmp/recon-ngreport-ip - %Timestamp%.txt" %DocumentacionIP%


"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngReport - %Timestamp%.html'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngreport-networks - %Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngreport-subdomains - %Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ngreport-ip - %Timestamp%.txt'"
"%~dp0plink.exe" -ssh -P 22 -l %Username% -pw %Password% -C %Server% "rm -f '/tmp/recon-ng-script_%Timestamp%.txt'"


echo %DocumentacionReport%
echo %DocumentacionNetworks%
echo %DocumentacionSubdomains%

pause