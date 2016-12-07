@echo off

@title=[Instalando/Actualizando Tools Externas Windows]
"%~dp0curl.exe" -o psexec.exe https://live.sysinternals.com/psexec.exe
"%~dp0curl.exe" -o plink.exe https://the.earth.li/~sgtatham/putty/latest/x86/plink.exe

pause
