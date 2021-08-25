#!/bin/bash
set -u

dotfilesDirectory=$HOME/.dotfiles

###========================================================================================###
###    Utility                                                                             ###
###========================================================================================###

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
###    Update                                                                              ###
###========================================================================================###

update() {

    cd $dotfilesDirectory

    if test -n "$(git status --porcelain)"; then
        git status
        warn "$dotfilesDirectoryに変更が存在します。更新を行うとすべての変更が破棄されます。"

        if ! ask_yes_or_no "本当に実行しますか？"; then
            info "キャンセルしました。"
            exit
        fi
    fi

    if [ "$UID" -eq "0" ]; then
        error "このスクリプトは通常ユーザーで実行してください。"
        exit 1
    fi

    info "dotfilesを更新します。"
    info "$dotfilesDirectory をorigin/mainの内容で上書きします。"
    git fetch
    git reset --hard origin/$(git symbolic-ref --short HEAD)
    git checkout main
    git reset --hard origin/main
    git pull --rebase

    if [ $# -ge 1 ]; then
        info "$1が指定されました。$1ブランチで実行します。"
        git fetch
        git checkout $1
        git reset --hard origin/$1
    fi

    /bin/bash $dotfilesDirectory/scripts/install.sh

}

update
