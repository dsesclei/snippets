These are shell scripts and batch files I use to maintain a YouTube video
archive. They are intended to be used with a mapped network drive letter
that holds a few files in the root directory and everything else under a
subdirectory called "YouTube Channels" - a bit misleading since it can all
work for BitChute and many other video hosts that youtube-dl or yt-dlp can
handle.

These were written with a Windows client/downloader with MSYS2 installed and
a Linux-based server to do the heavy lifting of files. The only shell script
used by MSYS2 is "generate_archive_batch_file.sh" which outputs a flat batch
file that does all the work repeatedly for each channel defined in the map
file "yt_channel_mappings.txt".

General workflow to use these is:

- Put youtube-dl.exe (I use a renamed yt-dlp.exe) in your PATH
- Map something to a network drive letter (The 'subst' command can be used to
  map an existing path to a virtual drive letter if needed) - I use Y:
- Copy the archive_root_scripts to the root of the mapped drive
- Copy the rest of the scripts to a subdirectory called "YouTube Channels"
- Make a "yt_channel_mappings.txt" text file in your Windows client
  - Line format: Channel Name=https://url_to_channel_page.com/c/WhateverItIs
  - Empty lines or lines starting with # are ignored (commented out)
- Open MSYS2
  - Do "cd /y" (or whatever letter you chose)
  - Run "./generate_archive_batch_file.sh" and wait
- Open command prompt
  - Type "Y:" (or your letter of choice)
  - Type "\perform_youtube_archive_update.bat" to run the generated downloader
  - Wait forever as it downloads everything for you
  - A file "\ytdl_archive.txt" will contain all downloaded video signatures
- On your Linux server hosting this mess (MSYS2/MinGW may work but not tested)
  - cd to the "YouTube Channels" directory
  - Run "./general_youtube_archive_cleanup.sh"
  - Wait as it moves metadata and any transcodings you've put in "encoded/"

If you transcode entire directories in HandBrake to make the files smaller,
placing the transcoded mp4 files in the channel's "encoded/" subdirectory will
make the archive cleanup script delete the originals and move the processed
transcoded files to "encoded/nodelete/" so they aren't processed again later.

For your very first run or after you add a new channel, you'll probably want
to edit the "download_entire_youtube_channel.bat" file which is called by the
generated downloader script to force "full" mode. Remove the @rem that sets
PLE to "-v" and every download will be a full channel download. The default is
to only fetch the last 50 videos added because it is faster and reduces the
traffic to YouTube, making it less likely that you hit the dreaded 429 error.
Remember to put the limit back in place later!

There are also several scripts that perform maintenance and helper tasks you
may find useful. The "scoring" scripts help to find channels that have high-
resolution or high-bitrate videos that will have a higher size reduction
payoff than others if you transcode them to smaller resolutions first. This is
extremely useful for finding channels that upload 4K content and transcoding
down to, say, 540p or 720p, saving a ton of disk space quickly. When you start
running low on space, you'll appreciate the scoring stuff to find targets for
your transcoding work.

Though very rare, there may be a time where you change your mind about
archiving a particular channel and want to throw it out. The problem is that
you can't simply delete the channel's subdirectory; you need to also remove
all references to that channel's videos in the YTDL archive file so that
any future runs don't consider these videos "already downloaded." You can use
the shell script "toss_entire_channel_and_unarchive.sh" to discard an entire
channel and clean references to its videos out of the archive. This allows you
to re-download it in the future if you change your mind again.

If you have bad intermediate download files that cause problems or you just
want to clear any unfinished download files before doing something like
transcoding an entire directory, the "nuke_temp_ytdl_files.sh" script will
clean up all intermediate files so you only have finished downloads in each
channel's directory.

You may want your transcoded files to have modification dates that match the
original upload date of the video. "set_nodelete_file_times_from_metadata.sh"
will extract the upload date from the downloaded metadata and set the file
modify date to match for every file you've transcoded. The original downloaded
files will have dates set by youtube-dl/yt-dlp but the transcoding process
loses this information. This lets you see videos in the original channel order
using standard file manager sorting tools rather than writing specialized
scripts that dig into the metadata files.
