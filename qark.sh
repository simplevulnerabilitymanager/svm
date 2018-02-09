#!/bin/bash
DirApp=$1
APK=$(echo $2 | sed 's/"//g')

cd $DirApp/qark

rm -fr report/build/ logs/ exploit/
python ./qarkMain.py --acceptterms ACCEPTTERMS --source 1 --pathtoapk "/tmp/$APK.apk" --debug 10 --reportdir "Report_$APK"
if [ -f build/qark/app/build/outputs/apk/app-debug.apk ] ; then
	mkdir exploit/
	cp build/qark/app/build/outputs/apk/app-debug.apk exploit/
fi

if [ -f build/qark/app/build/outputs/apk/app-debug-unaligned.apk ] ; then
	mkdir exploit/
	cp build/qark/app/build/outputs/apk/app-debug-unaligned.apk exploit/
fi





