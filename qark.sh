#!/bin/bash
DirApp=$1
APK=$(echo $2 | sed 's/"//g')

cd $DirApp

rm -fr report/build/ logs/ exploit/
qark --apk "/tmp/$APK.apk" --debug --exploit-apk --report-type html --sdk-path tools/
if [ -f build/qark/app/build/outputs/apk/app-debug.apk ] ; then
	mkdir exploit/
	cp build/qark/app/build/outputs/apk/app-debug.apk exploit/
fi

if [ -f build/qark/app/build/outputs/apk/app-debug-unaligned.apk ] ; then
	mkdir exploit/
	cp build/qark/app/build/outputs/apk/app-debug-unaligned.apk exploit/
fi





