function reload
  exec fish
end

function updateDotfiles
  /bin/bash $HOME/.dotfiles/scripts/install.sh
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

function git-peco
  git branch -a --sort=-authordate | grep -v -e '->' -e '*' | perl -pe 's/^\h+//g' | perl -pe 's#^remotes/origin/###' | perl -nle 'print if !$c{$_}++' | peco --prompt 'git switch > ' | xargs git switch | commandline ''
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