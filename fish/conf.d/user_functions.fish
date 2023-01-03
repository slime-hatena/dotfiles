function reload
  exec fish
end

function updateDotfiles
  /bin/bash $HOME/.dotfiles/scripts/update.sh $argv
end

function private
  fish --private
end

function peco
  command peco --layout=bottom-up --select-1 $argv
end

function cdp
  ls | peco | read dir
  if [ $dir ]
    cd $dir
  else
    commandline ''
  end
end

function ghq_peco
  ghq list -p | peco | read dir
  if [ $dir ]
    echo $dir
    cd $dir
  else
    commandline ''
  end
end

function __git_branch_peco
  git branch -a --sort=-authordate | grep -v -e '->' -e '*' | perl -pe 's/^\h+//g' | perl -pe 's#^remotes/origin/###' | perl -nle 'print if !$c{$_}++' | peco --prompt 'git switch > ' | xargs git switch | commandline ''
end

function __git_cd_peco
  ghq list | peco --prompt 'git switch > ' | read dir
    if [ $dir ]
      cd (ghq root)/$dir
    else
      commandline ''
    end
end

function __open_code
  code .
end

function shellgei
  docker run --rm -it theoldmoon0602/shellgeibot /bin/bash
end

function alpine
  docker run --rm -it alpine /bin/sh
end

function urlencode
  echo $argv | nkf -WwMQ | sed 's/=$//g' | tr = % | tr -d '\n'
end

function urldecode
  echo $argv | nkf -w --url-input
end

function unicode_escape
  echo $argv | sed 's/\\\u\(....\)/\&#x\1;/g' | nkf --numchar-input -w
end

function gitignore.io
  if test -f $argv
    echo '# Usage: gitignore.io lang1 lang2 ...'
    return
  end
  for item in $argv
    curl -L -s https://www.gitignore.io/api/$item
  end
end

function sql2tsv
  while read -l line
    echo $line | grep -v "mysql>" | grep -v "\->" | grep -v "+\-" | grep -v "rows in set" | grep -v "mysql> notee" | sed 's/^ *|//g' | sed 's/| *\n//g' | gsed -e "s/ *| */\t/g"
  end
end

function calc
  echo "scale=4; $argv" | bc
end

function ytdl
  mkdir -p ~/Videos/youtube-dl
  yt-dlp -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best --trim-filenames 64 --merge-output-format mkv -o "~/Videos/youtube-dl/%(title)s.%(ext)s" $argv
end

function ytdle
  echo "Target: /mnt/x/32/download_yt"
  if ! test -e /mnt/x/32/download_yt
    echo 'The target directory does not exist.'
    echo '> sudo mount -t drvfs X: /mnt/x'
    sudo mount -t drvfs X: /mnt/x
    echo '> mkdir -p /mnt/x/32/download_yt'
    mkdir -p /mnt/x/32/download_yt
  end
  yt-dlp -f bestvideo[ext=mp4]+bestaudio[ext=m4a]/best[ext=mp4]/best --trim-filenames 64 --merge-output-format mkv -o "/mnt/x/32/download_yt/%(title)s.%(ext)s" $argv
end

function ytdl-c
  ytdl --cookies ~/.youtube_cookie.tsv $argv
end

function parseKindleLibrary
  if string match -q -- "*microsoft*" (uname -r)
    xmllint --xpath "/response/add_update_list/meta_data/ASIN" "/mnt/c/Users/$USER/AppData/Local/Amazon/Kindle/Cache/KindleSyncMetadataCache.xml" | sed -e "s/<ASIN>//g" | sed -e "s/<\/ASIN>//g"
  else
    echo "Unsupported platform."
  end
end

function exif.kenko
  mkdir -p edited
  cp * ./edited
  cd ./edited
  ls | xargs -I {} exiftool -Make="Kenko" -Model="DSC Pieni" -FNumber="2.8" -FocalLength="3.2" -ISO="100" -ExposureTime="1/100" -overwrite_original_in_place {}
  cd ../
end
