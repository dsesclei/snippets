@echo off

tasklist /fi "imagename eq companionlink.exe" | find /i "companionlink.exe"
if %errorlevel% == 0 exit 0
echo Reviving CompanionLink.
start "CompanionLink" /min "c:\program files (x86)\companionlink\companionlink.exe" -Icon
exit 1