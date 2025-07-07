#!/usr/bin/env bash
set -u

dotfilesDirectory=$HOME/.dotfiles

. "$dotfilesDirectory/scripts/_functions.sh"

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
