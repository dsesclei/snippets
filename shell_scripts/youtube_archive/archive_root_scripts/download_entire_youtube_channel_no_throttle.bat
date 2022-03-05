set DLARCHIVE=Y:\ytdl_archive.txt
set COOKIEFILE=Y:\cookies.txt
set PLE=--playlist-end 50
if "%2"=="full" set PLE=""
youtube-dl %PLE% --match-filter "!is_live & !live" --cookies "%COOKIEFILE%" --add-metadata --write-description --write-info-json --write-thumbnail --download-archive "%DLARCHIVE%" --write-subs --write-auto-subs --sub-lang en,en_US --convert-subs srt -ciw -o "%%(title)s.%%(ext)s" -v %*
@rem youtube-dl --match-filter "!is_live & !live" --cookies "%COOKIEFILE%" --add-metadata --write-description --write-info-json --write-thumbnail --download-archive "%DLARCHIVE%" --write-subs --write-auto-subs --sub-lang en,en_US --convert-subs srt -ciw -o "%%(title)s.%%(ext)s" -v %*
@rem youtube-dl --match-filter "!is_live & !live" --cookies "%COOKIEFILE%" --add-metadata --write-description --write-info-json --write-thumbnail --download-archive "%DLARCHIVE%" --sleep-interval 1 -ciw -o "%%(title)s.%%(ext)s" -v %*