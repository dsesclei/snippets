set DLARCHIVE=Y:\ytdl_archive.txt
set COOKIEFILE=Y:\cookies.txt
youtube-dl --throttled-rate 20k --match-filter "!is_live & !live" --cookies "%COOKIEFILE%" --add-metadata --write-description --write-info-json --write-thumbnail --write-subs --write-auto-subs --sub-lang en,en_US --convert-subs srt -ciw -o "%%(title)s.%%(ext)s" -v %*