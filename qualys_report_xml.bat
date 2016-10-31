@echo off
cls
type %1 | "%~dp0xml.exe" sel -t -m "ASSET_DATA_REPORT/GLOSSARY/VULN_DETAILS_LIST/VULN_DETAILS" -v "QID[@id]" -o " - " -v "TITLE" -n 2>NUL | more
type %1 | "%~dp0xml.exe" sel -t -m "ASSET_DATA_REPORT/HOST_LIST/HOST" -n -v "IP" -m "VULN_INFO_LIST/VULN_INFO" -n -o "  QID:" -v "QID[@id]" -n -o "  Resultado:" -n -v "RESULT" -n -n 2>NUL | more
