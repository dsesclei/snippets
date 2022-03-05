rem This batch file uses youtube-dl.exe in PATH to download the latest 50 videos of the specified channel URL

set DLARCHIVE=Y:\ytdl_archive.txt
set COOKIES=--cookies Y:\cookies.txt
set PLE=--playlist-end 50
@rem Remove @rem from the next line to disable the "last 50 videos" limiter
@rem set PLE="-v"
if "%2"=="full" set PLE="-v"
if "%2"=="fullnc" set PLE="-v"
if "%2"=="fullnc" set COOKIES="-v"
youtube-dl %PLE% %COOKIES% --throttled-rate 50k --match-filter "!is_live & !live" --add-metadata --write-description --write-info-json --write-thumbnail --download-archive "%DLARCHIVE%" --write-subs --write-auto-subs --sub-lang en,en_US --convert-subs srt -ciw -o "%%(title)s.%%(ext)s" -v %*
@rem youtube-dl --match-filter "!is_live & !live" --cookies "%COOKIEFILE%" --add-metadata --write-description --write-info-json --write-thumbnail --download-archive "%DLARCHIVE%" --write-subs --write-auto-subs --sub-lang en,en_US --convert-subs srt -ciw -o "%%(title)s.%%(ext)s" -v %*
@rem youtube-dl --match-filter "!is_live & !live" --cookies "%COOKIEFILE%" --add-metadata --write-description --write-info-json --write-thumbnail --download-archive "%DLARCHIVE%" --sleep-interval 1 -ciw -o "%%(title)s.%%(ext)s" -v %*
