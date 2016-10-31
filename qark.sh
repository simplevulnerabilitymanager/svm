#!/bin/bash
DirApp=$1
APK=$(echo $2 | sed 's/"//g')

cd $DirApp

rm -fr report/build/ logs/ exploit/
python ./qark.py --acceptterms ACCEPTTERMS --source 1 --pathtoapk "/tmp/$APK.apk" --install 0 --exploit 1 --debug 10 --reportdir "Report_$APK"
mkdir exploit/
cp build/qark/app/build/outputs/apk/app-debug.apk exploit/
cp build/qark/app/build/outputs/apk/app-debug-unaligned.apk exploit/

