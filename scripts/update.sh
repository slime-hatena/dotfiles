#!/bin/bash
set -u

dotfilesDirectory=$HOME/.dotfiles

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

    if [ "$UID" -eq "0" ]; then
        error "このスクリプトは通常ユーザーで実行してください。"
        exit 1
    fi

    info "dotfilesを更新します。"
    info "$dotfilesDirectory をorigin/masterの内容で上書きします。"
    cd "$dotfilesDirectory"
    git fetch
    git reset --hard origin/$(git symbolic-ref --short HEAD)
    git checkout master
    git reset --hard origin/master
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
