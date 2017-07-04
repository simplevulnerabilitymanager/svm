@echo off
setlocal
set AppExe=%1
set FileJar=%2

@title=[JD-GUI] - %FileJar%
%AppExe% %FileJar%
