@echo off

if not exist %1 goto err

ffmpeg -i %1 -ac 2 %1.wav

if %errorlevel% EQU 0 goto end

:err
echo An error occurred. See above messages for information.
pause

:end
