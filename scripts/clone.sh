#!/usr/bin/env bash
set -eu

dotfilesDirectory=$HOME/.dotfiles

###========================================================================================###
###    Utility                                                                             ###
###========================================================================================###

### コマンドが存在するかを確認します。
### @return 存在する: 0
### @return 存在しない: 1
exists() {
    type "$1" >/dev/null 2>&1
}

### Yes/Noを尋ねます。未指定の場合はNoになります。
### @return yes: 0
### @return no: 1
ask_yes_or_no() {
    message="Are you sure?"
    if [ $# -eq 1 ]; then
        message=$1
    fi

    printf '\033[1;37;46m%s\033[m ' "$message [y/N]:"
    read -p "" yn
    case "$yn" in [yY]*) ;; *)
        return 1
        ;;
    esac
    return 0
}

###========================================================================================###
###    Print                                                                               ###
###========================================================================================###

info() {
    printf '\033[1;32m%s\033[m\n' "$1"
}

warn() {
    printf '\033[1;33m%s\033[m\n' "$1"
}

error() {
    printf '\033[1;37;41m%s\033[m\n' "$1"
}

###========================================================================================###
###    Clone                                                                               ###
###========================================================================================###

clone() {
    echo ""
    echo ""
    echo "           dotfiles by Slime-hatena"
    echo "          --------------------------"
    echo ""

    if [ "$UID" -eq "0" ]; then
        error "このスクリプトは通常ユーザーで実行してください。"
        exit 1
    fi

    if ! exists git; then
        error "このスクリプトを実行するにはgitが必要です。インストールして再度実行してください。"
        exit 1
    fi

    warn "このスクリプトを実行すると、あなたの環境に破壊的な変更が行われる可能性があります。"
    warn "実行結果に関しましては無保証です。個人の責任において実行してください。"
    warn "スクリプトの内容は以下から確認することができます。"
    warn "https://github.com/Slime-hatena/dotfiles/"
    echo ""

    sleep 5

    if ! ask_yes_or_no "本当に実行しますか？"; then
        info "キャンセルしました。"
        exit
    fi

    if [ -d "$dotfilesDirectory" ]; then
        info "$dotfilesDirectory をorigin/mainの内容で上書きします。"
        cd "$dotfilesDirectory"
        git fetch
        git reset --hard origin/$(git symbolic-ref --short HEAD)
        git checkout main
        git reset --hard origin/main
        git pull --rebase
    else
        info "https://github.com/Slime-hatena/dotfiles を $dotfilesDirectory にcloneします。"
        git clone https://github.com/Slime-hatena/dotfiles.git "$dotfilesDirectory"
        cd "$dotfilesDirectory"
    fi

    if [ $# -ge 1 ]; then
        info "$1が指定されました。$1ブランチで実行します。"
        git fetch
        git checkout $1
        git reset --hard origin/$1
    fi

    # 正常にcloneできているかを確認する
    if [ -d "$dotfilesDirectory" ]; then
        info "cloneに成功しました。"
        info "インストールスクリプトを実行します。"
        /bin/bash $dotfilesDirectory/scripts/install.sh
    else
        error "cloneに失敗しました。"
        exit 1
    fi
}

clone
