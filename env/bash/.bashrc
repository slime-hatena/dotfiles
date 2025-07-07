# 現在のシェルが「インタラクティブモード」で動作しているかどうかを判定するための構文です。
# インタラクティブモードでない場合、return コマンドでこのスクリプトの実行を即座に終了します。
case $- in
*i*) ;;
*) return ;;
esac

# ignoreboth は ignoredups と ignorespace の両方を有効にする設定です。
# ignoredups: 直前に実行したコマンドと全く同じコマンドは、履歴に保存しません。同じコマンドを何度も連続で実行しても、履歴には1つしか残らなくなります。
# ignorespace: 行頭がスペースで始まるコマンドは、履歴に保存しません。パスワードを含むコマンドなど、履歴に残したくない一時的なコマンドを実行する際に便利です。
HISTCONTROL=ignoreboth

# シェルを終了する際に、そのセッションで実行したコマンド履歴を履歴ファイル (~/.bash_history) に上書きするのではなく、追記するようになります。
# これにより、複数のターミナルを同時に開いていても、それぞれの履歴が失われることなく、すべてファイルに蓄積されます。
shopt -s histappend

# シェルがメモリ上に記憶しておくコマンド履歴の最大行数を設定します。
HISTSIZE=1000

# 履歴ファイル (~/.bash_history) に保存されるコマンド履歴の最大行数を設定します。
# これを超えた場合は、古いものから削除されます。
HISTFILESIZE=10000

# コマンドを実行するたびに、ターミナルウィンドウのサイズが変更されていないかを確認します。
# もし変更されていれば、ウィンドウの行数 (LINES) と桁数 (COLUMNS) を保持する変数を自動的に更新します。
# これにより、ls などのコマンドが、常に現在のウィンドウサイズに合わせた適切なレイアウトで表示されるようになります。
shopt -s checkwinsize

# lesspipe は、less が様々な種類のファイル（例: gzipで圧縮されたファイル、tarアーカイブ、manページなど）を直接閲覧できるようにするためのフィルタースクリプトです。
# このコマンドは lesspipe を実行し、そのが出力するシェルコマンド（環境変数の設定など）を eval を使って現在のシェルで実行します。
# これにより、less archive.tar.gz のように入力するだけで、lessが自動的に中身を展開して表示してくれるようになります。
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# ターミナルエミュレータを使用している場合に、ウィンドウのタイトルを自動的に「ユーザー名@ホスト名: 現在のディレクトリ」という形式で表示するための設定です。
case "$TERM" in
xterm* | rxvt*)
  PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
  ;;
*) ;;
esac

# ls コマンドをより便利に使うためのショートカット（エイリアス）を定義します。
# - ll: ls -alF のエイリアス。すべてのファイル（隠しファイル含む）を詳細なリスト形式で表示し、ファイルの種類を示す記号（/、*など）を末尾に付けます。非常によく使われる便利なコマンドです。
# - la: ls -A のエイリアス。. と .. を除くすべてのファイル（隠しファイル含む）を表示します。
# - l: ls -CF のエイリアス。ファイルをカラム（列）形式で表示します。
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# 時間のかかる処理の最後に alert を付けて実行すると、処理が完了したときにデスクトップ通知を送るためのエイリアスです。
# 使用例: sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# Tabキーを押したときにコマンドの引数やファイル名を自動で補完してくれる「コマンド補完機能」を有効にします。
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# PATH 環境変数の設定を ~/.bash_path という外部ファイルに記述できるようにするための設定です。
if [ -f "$HOME/.bash_path" ]; then
  . "$HOME/.bash_path"
fi
