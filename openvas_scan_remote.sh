#!/bin/bash
Proyecto=$1
IP=$2
Username=$3
Password=$4
ScanConfig=$5
FormatID=$6
Timestamp=$7

which xmlstarlet >/dev/null
if [ $? -ne 0 ] ; then
	echo "Falta el programa xmlstarlet. Instalelo primero"
	read -rsp 'Press any key to continue...\n' -n 1 key
	exit
fi

which basez >/dev/null
if [ $? -ne 0 ] ; then
	echo "Falta el programa basez. Instalelo primero"
	read -rsp 'Press any key to continue...\n' -n 1 key
	exit
fi

which omp >/dev/null
if [ $? -ne 0 ] ; then
	echo "Falta el programa openvas-client(omp). Instalelo primero"
	read -rsp 'Press any key to continue...\n' -n 1 key
	exit
fi

which netstat >/dev/null
if [ $? -ne 0 ] ; then
openvasmd_ip=$(ss -p -l | grep openvasmd | grep LISTEN | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b')
openvasmd_port=$(ss -p -l | grep openvasmd | grep LISTEN | grep -oE ':[0-9]{1,6}' | cut -d":" -f2)
else
openvasmd_ip=$(netstat -anp | grep openvasmd | grep LISTEN | grep -oE '\b([0-9]{1,3}\.){3}[0-9]{1,3}\b' | grep -v 0.0.0.0)
openvasmd_port=$(netstat -ltp | grep openvasmd | grep LISTEN | grep -oE ':[0-9]{1,6}' | cut -d":" -f2)
fi

Server=$openvasmd_ip
Port=$openvasmd_port

openvassd_status=$(ps ax | grep "openvassd: Reloaded" | grep -v grep)
while [ ! -z $openvassd_status ] ; do
	echo $openvassd_status
	ping -c 61 127.0.0.1 > /dev/null
done


#https://www.vmware.com/support/developer/vc-sdk/visdk400pubs/ReferenceGuide/timezone.html
#http://docs.greenbone.net/API/OMP/omp.html#command_modify_setting
#omp --host=$Server --port=$Port --username=$Username --password=$Password --xml="<modify_setting><name>Timezone</name><value>UTC</value></modify_setting>"

#http://docs.greenbone.net/API/OMP/omp.html#command_create_target
omp --host=$Server --port=$Port --username=$Username --password=$Password --xml="<create_target><name>\"$Proyecto-$Timestamp\"</name><hosts>$IP</hosts><alive_tests>Consider Alive</alive_tests><port_range>T:1-65535,U:7,9,13,17,19,21,37,53,67-69,98,111,121,123,135,137-138,161,177,371,389,407,445,456,464,500,512,514,517-518,520,555,635,666,858,1001,1010-1011,1015,1024-1049,1051-1055,1170,1194,1243,1245,1434,1492,1600,1604,1645,1701,1807,1812,1900,1978,1981,1999,2001-2002,2023,2049,2115,2140,2801,2967,3024,3129,3150,3283,3527,3700,3801,4000,4092,4156,4569,4590,4781,5000-5001,5036,5060,5321,5400-5402,5503,5569,5632,5742,6051,6073,6502,6670,6771,6912,6969,7000,7111,7222,7300-7301,7306-7308,7778,7789,7938,9872-9875,9989,10067,10167,11000,11223,12223,12345-12346,12361-12362,15253,15345,16969,17185,20001,20034,21544,21862,22222,23456,26274,26409,27444,30029,31335,31337-31339,31666,31785,31789,31791-31792,32771,33333,34324,40412,40421-40423,40426,47262,50505,50766,51100-51101,51109,53001,54321,61466</port_range></create_target>" 1> "/tmp/openvas_scan_target_$Timestamp.txt"
grep "OK" "/tmp/openvas_scan_target_$Timestamp.txt" 1>/dev/null
if [ $? -ne 0 ] ; then
	echo ---Error. Revise username/password o levante el servicio ejecutando:
	echo service openvas-scanner restart
	echo service openvas-manager restart
	echo service greenbone-security-assistant restart
	exit
fi

xmlstarlet sel -t -m "create_target_response" -v "@id" "/tmp/openvas_scan_target_$Timestamp.txt" > "/tmp/openvas_scan_target_id_$Timestamp.txt"
target_id=$(cat "/tmp/openvas_scan_target_id_$Timestamp.txt")


#http://docs.greenbone.net/API/OMP/omp.html#command_create_task
omp --host=$Server --port=$Port --username=$Username --password=$Password --xml="<create_task><name>\"$Proyecto-$Timestamp\"</name><config id=\"$ScanConfig\"></config><target id=\"$target_id\"></target></create_task>" 1> "/tmp/openvas_scan_task_$Timestamp.txt"
grep "Failed to find target" "/tmp/openvas_scan_task_$Timestamp.txt" 1>/dev/null
if [ $? -eq 0 ] ; then
	echo ---Error---
	exit
fi
grep "OK" "/tmp/openvas_scan_task_$Timestamp.txt" 1>/dev/null
if [ $? -ne 0 ] ; then
	echo ---Error---
	exit
fi

xmlstarlet sel -t -m "create_task_response" -v "@id" "/tmp/openvas_scan_task_$Timestamp.txt" > "/tmp/openvas_scan_task_id_$Timestamp.txt"
if [ $? -ne 0 ] ; then
	echo ---Error---
	exit
fi

task_id=$(cat "/tmp/openvas_scan_task_id_$Timestamp.txt")

#http://docs.greenbone.net/API/OMP/omp.html#command_start_task
omp --host=$Server --port=$Port --username=$Username --password=$Password --xml="<start_task task_id=\"$task_id\"></start_task>" 1> "/tmp/openvas_scan_report_$Timestamp.txt"
grep "OK" "/tmp/openvas_scan_report_$Timestamp.txt" 1>/dev/null
if [ $? -ne 0 ] ; then
	echo ---Error---
	exit
fi

xmlstarlet sel -t -v "start_task_response/report_id" "/tmp/openvas_scan_report_$Timestamp.txt" > "/tmp/openvas_scan_report_id_$Timestamp.txt"
report_id=$(cat "/tmp/openvas_scan_report_id_$Timestamp.txt")

echo Escaneando...
salir=0
while [ $salir -eq 0 ] ; do
	#http://docs.greenbone.net/API/OMP/omp.html#command_get_tasks
	omp --host=$Server --port=$Port --username=$Username --password=$Password --xml="<get_tasks task_id=\"$task_id\"></get_tasks>" 1> "/tmp/openvas_scan_status_report_$Timestamp.txt"
	xmlstarlet sel -t -v "get_tasks_response/task/status" "/tmp/openvas_scan_status_report_$Timestamp.txt" > "/tmp/openvas_scan_status_scan_$Timestamp.txt"
	grep "Internal Error" "/tmp/openvas_scan_status_scan_$Timestamp.txt" 1>/dev/null
	if [ $? -eq 0 ] ; then
		echo "Internal Error"
		salir=1
		rm "/tmp/openvas_scan_target_$Timestamp.txt"
		rm "/tmp/openvas_scan_target_id_$Timestamp.txt"
		rm "/tmp/openvas_scan_task_$Timestamp.txt"
		rm "/tmp/openvas_scan_task_id_$Timestamp.txt"
		rm "/tmp/openvas_scan_report_$Timestamp.txt"
		rm "/tmp/openvas_scan_report_id_$Timestamp.txt"
		rm "/tmp/openvas_scan_status_scan_$Timestamp.txt"
		exit 1
	fi
	
	grep "Stopped" "/tmp/openvas_scan_status_scan_$Timestamp.txt" 1>/dev/null
	if [ $? -eq 0 ] ; then
		echo "Stopped"
		rm "/tmp/openvas_scan_target_$Timestamp.txt"
		rm "/tmp/openvas_scan_target_id_$Timestamp.txt"
		rm "/tmp/openvas_scan_task_$Timestamp.txt"
		rm "/tmp/openvas_scan_task_id_$Timestamp.txt"
		rm "/tmp/openvas_scan_report_$Timestamp.txt"
		rm "/tmp/openvas_scan_report_id_$Timestamp.txt"
		rm "/tmp/openvas_scan_status_scan_$Timestamp.txt"
		salir=1
		exit 1
	fi
	grep "Done" "/tmp/openvas_scan_status_scan_$Timestamp.txt" 1>/dev/null
	if [ $? -eq 0 ] ; then
		salir=1
	else
		ping -c 61 127.0.0.1 > /dev/null
		date +"%T"
		salir=0
	fi
done

echo Generando Reporte...
#http://docs.greenbone.net/API/OMP/omp.html#command_get_reports
omp --host=$Server --port=$Port --username=$Username --password=$Password --xml="<get_reports report_id=\"$report_id\" filter=\"autofp=0 apply_overrides=1 notes=1 overrides=1 result_hosts_only=1 sort-reverse=severity levels=hml min_qod=70\" format_id=\"$FormatID\"/>" 1> "/tmp/openvas_scan_report_response_$Timestamp.txt"
xmlstarlet sel -t -v "get_reports_response/report/text()" "/tmp/openvas_scan_report_response_$Timestamp.txt" > "/tmp/openvas_scan_b64_report_$Timestamp.txt"
basez -d --base64 "/tmp/openvas_scan_b64_report_$Timestamp.txt" > "/tmp/OpenvasReport - $Timestamp.html"

rm "/tmp/openvas_scan_target_$Timestamp.txt"
rm "/tmp/openvas_scan_target_id_$Timestamp.txt"
rm "/tmp/openvas_scan_task_$Timestamp.txt"
rm "/tmp/openvas_scan_task_id_$Timestamp.txt"
rm "/tmp/openvas_scan_report_$Timestamp.txt"
rm "/tmp/openvas_scan_report_id_$Timestamp.txt"
rm "/tmp/openvas_scan_status_scan_$Timestamp.txt"
rm "/tmp/openvas_scan_status_report_$Timestamp.txt"
rm "/tmp/openvas_scan_report_response_$Timestamp.txt"
rm "/tmp/openvas_scan_b64_report_$Timestamp.txt"
