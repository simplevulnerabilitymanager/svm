#!/bin/bash
# Script que instala los programas que utiliza Simple Vulnerability Manager.
# Instalar en Kali/Debian/Ubuntu
# En Windows 10 con "Bash en Ubuntu en Windows" ejecutar antes:
# sc stop SshProxy
# sc stop SshBroker
# Luego modificar
# /etc/ssh/sshd_config
# ListenAddress 0.0.0.0
# UsePrivilegeSeparation no
# PasswordAuthentication yes
# service ssh start

apt-get update
apt-get install git wget python -y
apt-get install python3 python-pip -y
apt-get install python-dev -y
apt-get install build-essential -y
apt-get install ruby -y
apt-get install ruby-dev -y
apt-get install rubygems-integration -y
apt-get install rubygems -y 
apt-get install python-setuptools -y
apt-get install gcc -y
apt-get install awk -y

gem update
#Web Scan Tools (Arachni)
cd
apt-get install curl -y
apt-get install libcurl3 -y
apt-get install libcurl4-openssl-dev -y
apt-get install arachni -y
gem install watir-webdriver
gem install selenium-webdriver

#Information Tools
cd
apt-get install libxml2-dev libxslt1-dev zlib1g-dev -y
git clone https://LaNMaSteR53@bitbucket.org/LaNMaSteR53/recon-ng.git
if [ $? -ne 0 ] ; then
	cd recon-ng
	git pull
	pip install --upgrade -r REQUIREMENTS
else
	cd recon-ng
	pip install --upgrade -r REQUIREMENTS
fi


cd
git clone https://github.com/aboul3la/Sublist3r
if [ $? -ne 0 ] ; then
	cd Sublist3r
	git pull
	pip install --upgrade requests
	pip install --upgrade dnspython
	pip install --upgrade argparse
else
	cd Sublist3r
	pip install --upgrade requests
	pip install --upgrade dnspython
	pip install --upgrade argparse
fi

cd
apt-get install python3-pip -y
git clone https://github.com/mschwager/fierce
if [ $? -ne 0 ] ; then
	cd fierce
	git pull
	pip install --upgrade -r requirements.txt
	pip install --upgrade -r requirements-dev.txt	
else
	cd fierce	
	pip install --upgrade -r requirements.txt
	pip install --upgrade -r requirements-dev.txtd
fi



#Service Scan Tools (OpenVAS)
cd
apt-get install sqlite3 -y
apt-get install xsltproc -y
apt-get install texlive-latex-base -y
apt-get install nsis -y
apt-get install alien -y
apt-get install rpm -y
#Tool Extras
apt-get install nmap -y
nmap --script-updatedb
apt-get install nikto -y
apt-get install ike-scan -y
apt-get install lsof -y
apt-get install clamav -y
apt-get install clamav-data -y
apt-get install pnscan -y
apt-get install netdiag -y
apt-get install ldapscripts -y
grep "mrazavi" /etc/apt/sources.list
if [ $? -ne 0 ] ; then
	echo "deb http://ppa.launchpad.net/mrazavi/openvas/ubuntu xenial main" >> /etc/apt/sources.list
	echo "deb http://ppa.launchpad.net/mrazavi/greenbone-security-assistant/ubuntu devel main" >> /etc/apt/sources.list
	apt-key adv --recv-key --keyserver keyserver.ubuntu.com 3C453D244AA450E0
	apt-get update
	apt-get install greenbone-security-assistant -y	
	apt-get install openvas-cli -y
	apt-get install openvas-manager -y
	apt-get install openvas-scanner -y
	openvas-mkcert
	openvas-mkcert-client -n -i
	openvas-nvt-sync ; openvas-scapdata-sync ; openvas-certdata-sync
	service openvas-scanner restart
	service openvas-manager restart
	openvasmd --rebuild --progress
	openvasmd --user=admin --new-password=OpenVAS	#Reset password
else
	apt-get install greenbone-security-assistant -y	
	apt-get install openvas-cli -y	
	apt-get install openvas-manager -y
	apt-get install openvas-scanner -y
	openvas-nvt-sync ; openvas-scapdata-sync ; openvas-certdata-sync
	openvasmd --rebuild --progress
fi


#Service Scan Tools (Nessus)
cd
/opt/nessus/sbin/nessuscli update --plugins-only


#JAVA
apt-get install openjdk-8-jdk -y
if [ $? -ne 0 ] ; then
	apt-get install openjdk-7-jdk -y
fi
#mkdir /opt
#Download java 
#http://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html
#tar -xzvf /opt/jdk-8u101-linux-x64.tar.gz
#cd /opt/jdk-8u101

#3.This step registers the downloaded version of Java as an alternative, and switches it to be used as the default:
#update-alternatives --install /usr/bin/java java /opt/jdk1.7.0_17/bin/java 1
#update-alternatives --install /usr/bin/javac javac /opt/jdk1.7.0_17/bin/javac 1
#update-alternatives --install /usr/lib/mozilla/plugins/libjavaplugin.so mozilla-javaplugin.so /opt/jdk1.7.0_17/jre/lib/amd64/libnpjp2.so 1
#update-alternatives --set java /opt/jdk1.7.0_17/bin/java
#update-alternatives --set javac /opt/jdk1.7.0_17/bin/javac
#update-alternatives --set mozilla-javaplugin.so /opt/jdk1.7.0_17/jre/lib/amd64/libnpjp2.so

#4. Test
#To check the version of Java you are now running
java -version

#Mobile Tools
cd
apt-get install android-tools-adb -y

#Mobile Tools (ApkTools)
cd
mkdir apktool
cd apktool
wget https://bitbucket.org/iBotPeaches/apktool/downloads/ -O index.html
UltimaVersion=$(grep "apktool_" index.html  | head -1  | awk -F '"' '{print $2}' | awk -F '/' '{print $5}')
LinkDownload=$(grep "apktool_" index.html  | head -1  | awk -F '"' '{print $2}')
if [ ! -f $UltimaVersion ] ; then
	wget https://bitbucket.org/$LinkDownload -O $UltimaVersion
fi
rm -fr index.html


#Mobile Tools
cd
mkdir androidsdk
cd androidsdk
if [ ! -f android-sdk_r24.4.1-linux.tgz ] ; then
	wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -O android-sdk_r24.4.1-linux.tgz
	tar -xvzf android-sdk_r24.4.1-linux.tgz
	wget https://dl.google.com/dl/android/studio/ide-zips/2.1.2.0/android-studio-ide-143.2915827-linux.zip -O android-studio-ide-143.2915827-linux.zip
	unzip android-studio-ide-143.2915827-linux.zip
	cd android-studio/bin
	./studio.sh
fi

#Mobile Tools (Drozer)
cd
apt-get install protobuf-compiler -y
apt-get install dex2jar -y
apt-get install python-setuptools -y
git clone https://github.com/mwrlabs/drozer
if [ $? -ne 0 ] ; then
	cd drozer
	git pull	
	make
	python setup.py build
	python setup.py install
else
	cd drozer
	make
	python setup.py build
	python setup.py install
fi

#Mobile Tools (Enjarify)
cd
git clone https://github.com/google/enjarify
if [ $? -ne 0 ] ; then
	cd enjarify
	git pull
fi

#Mobile Tools (Qark)
cd
git clone https://github.com/linkedin/qark
if [ $? -ne 0 ] ; then
	cd qark
	git pull
fi

#Mobile Tools (MobSF)
apt-get install libffi-dev -y
apt-get install libtiff5-dev -y
apt-get install libjpeg8-dev -y
apt-get install zlib1g-dev -y
apt-get install libfreetype6 -y
apt-get install libfreetype6-dev -y
apt-get install liblcms2-dev -y
apt-get install libwebp-dev -y
apt-get install tcl8.6-dev -y
apt-get install tk8.6-dev -y
apt-get install python-tk -y
apt-get install libssl-dev -y
apt-get install libjpeg62-dev -y
apt-get install libjpeg62-turbo-dev -y
pip install --upgrade Scrapy
pip install --upgrade cryptography
pip install --upgrade cffi
pip install --upgrade pycparser
cd
git clone https://github.com/ajinabraham/Mobile-Security-Framework-MobSF
if [ $? -ne 0 ] ; then
	cd Mobile-Security-Framework-MobSF
	git pull
	pip install -r requirements.txt --upgrade
	python ./manage.py migrate
else
	cd Mobile-Security-Framework-MobSF
	pip install -r requirements.txt --upgrade
fi

#Mobile Tools (AndroBugs_Framework)
cd
git clone https://github.com/AndroBugs/AndroBugs_Framework
if [ $? -ne 0 ] ; then
	cd AndroBugs_Framework
	git pull
fi


echo "Termino"



