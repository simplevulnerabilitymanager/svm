#!/bin/bash
OpenvasUsername=$1
OpenvasPassword=$2
Timestamp=$3

which netstat
if [ $? -ne 0 ] ; then
openvasmd_ip=$(ss -p -l | grep openvasmd | grep LISTEN | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
openvasmd_port=$(ss -p -l | grep openvasmd | grep LISTEN | grep -oE ':[0-9]{1,6}' | cut -d":" -f2)
else
openvasmd_ip=$(netstat -anp | grep openvasmd | grep LISTEN | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | grep -v 0.0.0.0)
openvasmd_port=$(netstat -ltp | grep openvasmd | grep LISTEN | grep -oE ':[0-9]{1,6}' | cut -d":" -f2)
fi

which omp >/dev/null
if [ $? -ne 0 ] ; then
	echo "Falta el programa openvas-client(omp). Instalelo primero"
	read -rsp 'Press any key to continue...\n' -n 1 key
	exit
fi

omp --host=$openvasmd_ip --port=$openvasmd_port --username=$OpenvasUsername --password=$OpenvasPassword --xml='<get_configs />' 1> /tmp/openvas_scan_configs_$Timestamp.txt 2>/dev/null

