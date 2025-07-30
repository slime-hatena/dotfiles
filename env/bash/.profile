# bashをデフォルトシェルとし、ログインシェルとして起動する前提です。
# .bashrcを読み込み、zshがインストールされていれば起動します。
# （設定やパスをzsh/bashで共有する目的があります）
# もしbashを使用したい場合はzshからbashを起動します。
# （非ログインインタラクティブシェルとして起動されます）

# brewでインストールされたzshが存在すればそれを、なければbashをデフォルトシェルに設定
DEFAULT_SHELL="/usr/bin/env bash"
# brewが存在し、かつbrewでインストールされたzshが存在する場合はそれをデフォルトシェルに設定
if command -v brew >/dev/null 2>&1; then
    eval "$($(brew --prefix)/bin/brew shellenv)"

    BREW_ZSH="$(brew --prefix)/bin/zsh"
    if [ -x "$BREW_ZSH" ]; then
        DEFAULT_SHELL="$BREW_ZSH"
    fi
fi

# XDG Base Directoryの設定
# https://wiki.archlinux.jp/index.php/XDG_Base_Directory
export XDG_CONFIG_HOME=$HOME/.config
export XDG_CACHE_HOME=$HOME/.cache
export XDG_DATA_HOME=$HOME/.local/share
export XDG_STATE_HOME=$HOME/.local/state

# パスの設定
export GOPATH="$HOME/go"
export PATH="$PATH:$GOPATH/bin"
export PROTO_HOME="$XDG_DATA_HOME/proto";
export PATH="$PROTO_HOME/shims:$PROTO_HOME/bin:$PATH";

# その他の設定
export HOMEBREW_NO_ENV_HINTS=1

# bashなら.bashrcを読み込む
if [ -n "$BASH_VERSION" ]; then
    if [ -f "$HOME/.bashrc" ]; then
        . "$HOME/.bashrc"
    fi
fi

# コマンドが指定されている場合は実行して終了
if [ -n "$BASH_EXECUTION_STRING" ]; then
    # echo "> /bin/bash -c \"$BASH_EXECUTION_STRING\""
    /bin/bash -c "$BASH_EXECUTION_STRING"
    exit $?
fi

$DEFAULT_SHELL
if [ $? -eq 0 ]; then
    exit 0
fi
echo "${DEFAULT_SHELL}の起動に失敗しました。インストールされているか、パスが通っているかを確認してください。"
