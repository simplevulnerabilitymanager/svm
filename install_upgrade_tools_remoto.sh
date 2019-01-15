#!/bin/bash
# Script que instala los programas que utiliza Simple Vulnerability Manager.
# Instalar en Kali/Debian/Ubuntu
# En Windows 10 con "Ubuntu 18.04" o "Kali" ejecutar antes: (Download from Microsoft Store)
#
# sudo apt-get install openssh-server
# cd /etc/ssh/
# sudo /usr/bin/ssh-keygen -A
# sudo service ssh --full-restart
#
# sudo nano /etc/ssh/sshd_config
# Agregar lo siguiente:
# ListenAddress 0.0.0.0
#
# Reiniciar el servicio
# sudo service ssh --full-restart
# sudo update-rc.d ssh enable
#
# Error: sudo: a password is required
# FIX:
# sudo visudo
# ulises2k ALL=(ALL) NOPASSWD: ALL
TOOL=$1

export TERM=linux
export DEBIAN_FRONTEND="noninteractive"
#echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections
#dpkg-reconfigure debconf

apt-get update
apt-get install git -y
apt-get install wget -y
apt-get install python -y
apt-get install python3 -y
apt-get install python3-dev -y
apt-get install python3-pip -y
apt-get install python3-dugong -y
apt-get install python-pip -y
apt-get install python-dev -y
apt-get install build-essential -y
apt-get install ruby -y
apt-get install ruby-dev -y
apt-get install rubygems-integration -y
apt-get install rubygems -y
apt-get install python-setuptools -y
apt-get install gcc -y
apt-get install awk -y
apt-get install original-awk -y
apt-get install xmlstarlet -y
#apt-get install basez -y

#Web Scan Tools (Arachni)
if [ $TOOL == "Arachni" ] || [ $TOOL == "Todas" ] ; then
	cd
	apt-get install libsqlite3-dev -y
	apt-get install libpq-dev -y
	apt-get install postgresql-server-dev-10 -y
	apt-get install default-libmysqlclient-dev -y
	apt-get install curl -y
	apt-get install libcurl3 -y
	apt-get install libcurl4-openssl-dev -y
	apt-get install arachni -y
	gem update
	gem install watir-webdriver
	gem install watir
	gem install selenium-webdriver
	gem install arachni-reactor
	gem install arachni-rpc
fi


#Information Tools (Recon-ng)
if [ $TOOL == "Recon-ng" ] || [ $TOOL == "Todas" ] ; then
	cd
	apt-get install dos2unix -y
	apt-get install libxml2-dev -y
	apt-get install libxslt1-dev -y
	apt-get install zlib1g-dev -y
	git clone https://LaNMaSteR53@bitbucket.org/LaNMaSteR53/recon-ng
	if [ $? -ne 0 ] ; then
		cd recon-ng
		git pull
		pip install --upgrade -r REQUIREMENTS
	else
		cd recon-ng
		pip install --upgrade -r REQUIREMENTS
	fi
fi

#Information Tools (EyeWitness)
if [ $TOOL == "EyeWitness" ] || [ $TOOL == "Todas" ] ; then
	cd
	git clone https://github.com/ChrisTruncer/EyeWitness
	if [ $? -ne 0 ] ; then
		cd EyeWitness
		git pull
	else
		cd EyeWitness
		cd setup
		chmod 755 setup.sh
		./setup.sh
	fi
fi


#Service Scan Tools (OpenVAS)
if [ $TOOL == "OpenVAS" ] || [ $TOOL == "Todas" ] ; then
	cd
	apt-get install sqlite3 -y
	apt-get install xsltproc -y
	apt-get install texlive-latex-base -y
	apt-get install texlive-latex-extra -y
	apt-get install texlive-fonts-recommended -y
	#apt-get install nsis -y
	apt-get install alien -y
	#apt-get install rpm -y
	#Tool Extras
	apt-get install nmap -y
	nmap --script-updatedb
	apt-get install nikto -y
	apt-get install ike-scan -y
	apt-get install lsof -y
	#apt-get install clamav -y
	#apt-get install clamav-data -y
	apt-get install pnscan -y
	apt-get install netdiag -y
	apt-get install ldapscripts -y
	apt-get install dirmngr -y
	apt-get install killall -y
	apt-get install hydra -y


	lsb_release -d | grep "Kali"
	if [ $? -eq 0 ] ; then
		which openvasmd	# para Kali
		if [ $? -ne 0 ] ; then
			apt-get install openvas openvas-manager openvas-manager-common openvas-cli openvas-scanner libopenvas9 greenbone-security-assistant greenbone-security-assistant-common -y
			dpkg --configure openvas
			openvas-setup
			openvasmd --create-user=admin --role=Admin
			openvasmd --user=admin --new-password=OpenVAS	#Default password en SVM
		fi
	else
		CODENAME=$(lsb_release -c | awk '{ print $2}')
		cd /etc/apt/
		grep -R mrazavi *
		if [ $? -ne 0 ] ; then
			echo "deb http://ppa.launchpad.net/mrazavi/openvas/ubuntu $CODENAME main" >> /etc/apt/sources.list
			# OpenPGP keys: - https://launchpad.net/~mrazavi
			#apt-key adv --recv-key --keyserver keyserver.ubuntu.com 57A42CB9
			#apt-key adv --recv-key --keyserver keyserver.ubuntu.com 90A921F1
			#apt-key adv --recv-key --keyserver keyserver.ubuntu.com 4AA450E0
			add-apt-repository ppa:mrazavi/openvas

			apt-get update

			apt-get install openvas9 -y
			apt-get install greenbone-security-assistant9 -y
			openvasmd --create-user=admin --role=Admin
			openvasmd --user=admin --new-password=OpenVAS	#Default password en SVM
		fi

		cd
	fi



	# Configurar la Web de OpenVAS para poder acceder remotamente
	which ifconfig
	if [ $? -ne 0 ] ; then
		IP_ADDRESS=$(ip addr show  | grep -Po 'inet \K[\d.]+' | grep -v 127.0.0.1 | head -1)
	else
		IP_ADDRESS=$(ifconfig | awk '{ print $2}' | grep -oE "([0-9]{1,3}[\.]){3}[0-9]{1,3}" | grep -v 127.0.0.1 | head -1)
	fi

	which gsad
	if [ $? -eq 0 ] ; then
		if [ ! -z $IP_ADDRESS ] ; then
			sed -i s/--listen=127.0.0.1/--listen=$IP_ADDRESS/g /lib/systemd/system/greenbone-security-assistant.service
			systemctl daemon-reload
			/etc/init.d/greenbone-security-assistant restart
		fi
	fi

	/etc/init.d/redis-server start
	service greenbone-security-assistant start	#Kali
	/etc/init.d/openvas-gsa start	#Ubuntu
	service openvas-scanner start
	service openvas-manager start


#grep "mrazavi" /etc/apt/sources.list
#if [ $? -ne 0 ] ; then
#	echo "deb http://ppa.launchpad.net/mrazavi/openvas/ubuntu xenial main" >> /etc/apt/sources.list
#	echo "deb http://ppa.launchpad.net/mrazavi/greenbone-security-assistant/ubuntu devel main" >> /etc/apt/sources.list
#	# OpenPGP keys: - https://launchpad.net/~mrazavi
#	apt-key adv --recv-key --keyserver keyserver.ubuntu.com 57A42CB9
#	apt-key adv --recv-key --keyserver keyserver.ubuntu.com 90A921F1
#	apt-get update
#
#	apt-get install greenbone-security-assistant -y
#	#apt-get install openvas-cli -y
#	#apt-get install openvas-manager -y
#	#apt-get install openvas-scanner -y
#	apt-get install openvas9 -y
#
#	database_version=$(openvasmd --check-alerts 2>&1)
#	if [ ! -z "$database_version" ] ; then
#		openvasmd --migrate
#		openvasmd --update --progress
#		openvasmd --rebuild --progress
#	fi

#	#openvas-mkcert -f				#Openvas 8
#	#openvas-mkcert-client -n -i		#Openvas 8
#	#LOG: openvas_server_verify: the certificate has expired
#	#FIX:Updating Scanner Certificates ( https://svn.wald.intevation.org/svn/openvas/trunk/openvas-manager/INSTALL )
#	#openvas-mkcert					#Openvas 8
#	#Status message: Service temporarily down openvas
#	#openvas-mkcert-client -n om -i	#Openvas 8
#	#
#	mkdir -p /var/lib/openvas/CA
#	mkdir -p /var/lib/openvas/private/CA/
#	openvasmd --create-scanner-ca-pub /var/lib/openvas/CA/cacert.pem
#	openssl verify -CAfile /var/lib/openvas/CA/cacert.pem /var/lib/openvas/CA/servercert.pem
#	openssl verify -CAfile /var/lib/openvas/CA/cacert.pem /var/lib/openvas/CA/clientcert.pem
#	#wget "https://svn.wald.intevation.org/svn/openvas/branches/openvas-scanner-5.0/tools/openvas-manage-certs.sh" -o openvas-manage-certs.sh
#	#chmod 755 openvas-manage-certs.sh
#	#openvas-manage-certs -V
#	openvasmd --modify-scanner $(openvasmd --get-scanners) --scanner-ca-pub /var/lib/openvas/CA/cacert.pem --scanner-key-pub /var/lib/openvas/CA/clientcert.pem --scanner-key-priv /var/lib/openvas/private/CA/clientkey.pem
#
#
#	#openvas-nvt-sync ; openvas-scapdata-sync ; openvas-certdata-sync	#Openvas 8
#	greenbone-certdata-sync; greenbone-nvt-sync ; greenbone-scapdata-sync	#Openvas 9
#
#	IP_ADDRESS=$(ifconfig eth0 | awk '{ print $2}' | grep -oE "([0-9]{1,3}[\.]){3}[0-9]{1,3}")
#	sed -i s/--listen=127.0.0.1/--listen=$IP_ADDRESS/g /lib/systemd/system/greenbone-security-assistant.service
#	sed -i s/--mlisten=127.0.0.1/--mlisten=$IP_ADDRESS/g /lib/systemd/system/greenbone-security-assistant.service
#	sed -i s/--listen=127.0.0.1/--listen=$IP_ADDRESS/g /lib/systemd/system/openvas-manager.service
#	systemctl daemon-reload
#
#	service greenbone-security-assistant start
#	service openvas-manager start
#	service openvas-scanner start
#
#	openvasmd --create-user=admin --role=Admin
#	openvasmd --user=admin --new-password=OpenVAS	#Reset password
#else
#	#Openvas Remove
#	#apt-get remove --purge greenbone-security-assistant openvas-cli openvas-manager openvas-scanner
#	#dpkg --purge --force-depends greenbone-security-assistant openvas-cli openvas-manager openvas-scanner
#	#
#	#Remover por completo toda la configuracion
#	#OIFS="$IFS"
#	#IFS=$'\n'
#	#for x in $(dpkg -S openvas) ; do
#	#	x1=$(echo $x|cut -d':' -f1)
#	#	x2=$(echo $x|cut -d':' -f2|sed 's/ //g')
#	#	if [ "$x1" == "openvas-manager-common" ] ; then
#	#		rm -fr $x2
#	#	fi
#	#	if [ "$x1" == "greenbone-security-assistant-common" ] ; then
#	#		rm -fr $x2
#	#	fi
#	#	if [ "$x1" == "libopenvas9" ] ; then
#	#		rm -fr $x2
#	#	fi
#	#done
#
#
#	#Openvas Reinstall
#	#apt-get -o Dpkg::Options::="--force-confmiss" -o Dpkg::Options::="--force-confnew" install --reinstall greenbone-security-assistant openvas-cli openvas-manager openvas-scanner
#
#	apt-get install greenbone-security-assistant -y
#	apt-get install openvas-cli -y
#	apt-get install openvas-manager -y
#	apt-get install openvas-scanner -y
#
#	database_version=$(openvasmd --check-alerts 2>&1)
#	if [ ! -z "$database_version" ] ; then
#		openvasmd --migrate
#		openvasmd --update --progress
#		openvasmd --rebuild --progress
#	fi
#
#	#openvas-nvt-sync ; openvas-scapdata-sync ; openvas-certdata-sync	#Openvas 8
#	greenbone-certdata-sync; greenbone-nvt-sync ; greenbone-scapdata-sync	#Openvas 9
#fi

fi

if [ $TOOL == "OpenVASPlugins" ] || [ $TOOL == "Todas" ] ; then

	greenbone-certdata-sync; greenbone-nvt-sync ; greenbone-scapdata-sync
	openvas-nvt-sync ; openvas-scapdata-sync ; openvas-certdata-sync

fi
#Service Scan Tools (NessusPlugins)
if [ $TOOL == "NessusPlugins" ] || [ $TOOL == "Todas" ] ; then
	cd
	/opt/nessus/sbin/nessuscli update --plugins-only
fi


#Service Scan Tools (Nmap)
if [ $TOOL == "Nmap" ] || [ $TOOL == "Todas" ] ; then
	cd
	apt-get install nmap -y
	nmap --script-updatedb
fi


#JAVA
if [ $TOOL == "Java" ] || [ $TOOL == "Todas" ] ; then
	apt-get install openjdk-9-jdk -y
	if [ $? -ne 0 ] ; then
		apt-get install openjdk-8-jdk -y
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
fi

#Mobile Tools (AndroidSDK)
if [ $TOOL == "AndroidSDK" ] || [ $TOOL == "Todas" ] ; then
	cd
	apt-get install android-tools-adb -y

	mkdir androidsdk
	cd androidsdk
	if [ ! -f android-sdk_r24.4.1-linux.tgz ] ; then
		wget https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz -O android-sdk_r24.4.1-linux.tgz
		tar -xvzf android-sdk_r24.4.1-linux.tgz
		cd android-sdk-linux

		echo "Ejecute en la terminal Linux el siguientes comandos:"
		echo "tools/android update sdk --no-ui"

		#wget https://dl.google.com/dl/android/studio/ide-zips/2.1.2.0/android-studio-ide-143.2915827-linux.zip -O android-studio-ide-143.2915827-linux.zip
		#unzip android-studio-ide-143.2915827-linux.zip
		#cd android-studio/bin
	fi
fi

#Mobile Tools (ApkTools)
if [ $TOOL == "ApkTools" ] || [ $TOOL == "Todas" ] ; then
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
fi

#Mobile Tools (Drozer)
if [ $TOOL == "Drozer" ] || [ $TOOL == "Todas" ] ; then
	cd
	apt-get install protobuf-compiler -y
	apt-get install dex2jar -y
	apt-get install python-setuptools -y
	apt-get install python-yaml -y
	apt-get install python-service-identity -y
	pip install --upgrade pyopenssl
	rm -fr drozer	#Opcional
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
fi

#Mobile Tools (Enjarify)
if [ $TOOL == "Enjarify" ] || [ $TOOL == "Todas" ] ; then
	cd
	rm -fr enjarify
	git clone https://github.com/google/enjarify
	if [ $? -ne 0 ] ; then
		cd enjarify
		git pull
	fi
fi

#Mobile Tools (Qark)
if [ $TOOL == "Qark" ] || [ $TOOL == "Todas" ] ; then
	cd
	rm -fr qark	#Opcional
	git clone https://github.com/linkedin/qark
	if [ $? -ne 0 ] ; then
		cd qark
		git pull
	else
		cd qark
		echo "Ejecute en la terminal Linux los siguientes comandos:"
		echo "cd /root/qark/qark/"
		echo "python ./qarkMain.py"
		echo "cd /root/qark/qark/android-sdk_r24.3.4-linux/android-sdk-linux"
		echo "tools/android update sdk --no-ui"

		python ./setup.py  install
	fi
fi

#Mobile Tools (MobSF)
if [ $TOOL == "MobSF" ] || [ $TOOL == "Todas" ] ; then
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
	apt-get install wkhtmltopdf -y
	pip install --upgrade scrapy
	pip install --upgrade cryptography
	pip install --upgrade cffi
	pip install --upgrade pycparser

	cd
	rm -fr Mobile-Security-Framework-MobSF	#Opcional
	git clone https://github.com/ajinabraham/Mobile-Security-Framework-MobSF
	#wget https://github.com/ajinabraham/Mobile-Security-Framework-MobSF/archive/v0.9.3.tar.gz -O Mobile-Security-Framework-MobSF.tar.gz
	# git clone https://github.com/ajinabraham/Mobile-Security-Framework-MobSF/tree/v0.9.3
	if [ $? -ne 0 ] ; then
		cd Mobile-Security-Framework-MobSF
		git pull
		pip install -r requirements.txt --upgrade
		python ./manage.py migrate
	else
		cd Mobile-Security-Framework-MobSF
		pip install -r requirements.txt --upgrade
	fi
fi

#Mobile Tools (AndroBugs_Framework)
if [ $TOOL == "AndroBugs_Framework" ] || [ $TOOL == "Todas" ] ; then
	cd
	rm -fr AndroBugs_Framework	#Opcional
	git clone https://github.com/AndroBugs/AndroBugs_Framework
	if [ $? -ne 0 ] ; then
		cd AndroBugs_Framework
		git pull
	fi
fi

#Restore
#echo 'debconf debconf/frontend select Dialog' | debconf-set-selections
echo "Termino"




