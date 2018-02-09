#!/bin/bash
OpenvasUsername=$1
OpenvasPassword=$2
OpenvasmdIP=$3
OpenvasmdPort=$4
Timestamp=$5

#which netstat >/dev/null
#if [ $? -ne 0 ] ; then
#OpenvasmdIP=$(ss -p -l | grep openvasmd | grep LISTEN | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
#OpenvasmdPort=$(ss -p -l | grep openvasmd | grep LISTEN | grep -oE ':[0-9]{1,6}' | cut -d":" -f2)
#else
#OpenvasmdIP=$(netstat -anp | grep openvasmd | grep LISTEN | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | grep -v 0.0.0.0)
#OpenvasmdPort=$(netstat -ltp | grep openvasmd | grep LISTEN | grep -oE ':[0-9]{1,6}' | cut -d":" -f2)
#fi

Server=$OpenvasmdIP
Port=$OpenvasmdPort

if [ -z $Server ] ; then
	Server=127.0.0.1
fi

if [ -z $Port ] ; then
	Port=9390
fi

which omp >/dev/null
if [ $? -ne 0 ] ; then
	echo "Falta el programa openvas-client(omp). Instalelo primero"
	read -rsp 'Press any key to continue...\n' -n 1 key
	exit
fi

openvassd_status=$(ps ax | grep "openvassd: Reloaded" | grep -v grep)
while [ ! -z $openvassd_status ] ; do
	echo $openvassd_status
	ping -c 61 127.0.0.1 > /dev/null
done

omp --host=$Server --port=$Port --username=$OpenvasUsername --password=$OpenvasPassword --xml='<get_configs />' 1> /tmp/openvas_scan_configs_$Timestamp.txt 2> /tmp/openvas_scan_configs_$Timestamp.txt

