#!/bin/sh
set -u

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

### ファイルが存在する場合は待避し、シンボリックリンクを作成します。
create_symbolic() {
    info "${1} → ${2} のシンボリックリンクを作成します。"
    if [ -e "$2" ]; then
        if [ -L "$2" ]; then
            warn "シンボリックリンクが存在します。削除します。"
            rm "$2"
        elif [ -d $2 ]; then
            filename=$(basename $2).$(date +%s)
            info "ディレクトリが存在します。${dotfilesDirectory}/backup/${filename}に移動します。"
            mkdir -p "${dotfilesDirectory}/backup/${filename}"
            mv "$2" "${dotfilesDirectory}/backup/${filename}"
        else
            filename=$(basename $2).$(date +%s)
            info "ファイルが存在します。${dotfilesDirectory}/backup/${filename}に移動します。"
            mv "$2" "${dotfilesDirectory}/backup/${filename}"
        fi
    fi
    ln -s "$1" "$2"
}

### Yes/Noを尋ねます。未指定の場合はNoになります。
### @return yes: 0
### @return no: 1
ask_yes_or_no() {
    message="Are you sure?"
    if [ $# -eq 1 ]; then
        message=$1
    fi

    printf '\033[1;30;46m%s\033[m ' "$message [y/N]:"
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
###    Main                                                                                ###
###========================================================================================###

main() {
    echo "##############################################################"
    echo "##############################################################"
    echo "##                                                          ##"
    echo "##     ■■■          ■■      ■■■  ■■  ■■■                    ##"
    echo "##      ■■          ■■     ■■         ■■                    ##"
    echo "##      ■■   ■■■■  ■■■■■    ■   ■■■   ■■   ■■■■    ■■■■■    ##"
    echo "##   ■■■■■  ■■  ■■  ■■    ■■■■   ■■   ■■  ■■  ■■  ■■        ##"
    echo "##  ■■  ■■  ■■  ■■  ■■     ■■    ■■   ■■  ■■■■■■   ■■■■■    ##"
    echo "##  ■■  ■■  ■■  ■■  ■■ ■■  ■■    ■■   ■■  ■■           ■■   ##"
    echo "##   ■■■■■■  ■■■■    ■■■  ■■■■  ■■■■ ■■■■  ■■■■■  ■■■■■■    ##"
    echo "##                                       by Slime-hatena    ##"
    echo "##                                                          ##"
    echo "##############################################################"
    echo "##############################################################"
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
    warn "スクリプトの内容は以下から確認することができます。"
    warn "https://github.com/Slime-hatena/dotfiles/"
    echo ""

    sleep 2

    if ! ask_yes_or_no "本当に実行しますか？"; then
        info "キャンセルしました。"
        exit;
    fi


    if [ -d "$dotfilesDirectory" ]; then
        info "$dotfilesDirectory を git pull --rebaseします。"
        cd "$dotfilesDirectory"
        git checkout master
        git pull --rebase
    else
        info "https://github.com/Slime-hatena/dotfiles を $dotfilesDirectory にcloneします。"
        git clone https://github.com/Slime-hatena/dotfiles.git "$dotfilesDirectory"
        cd "$dotfilesDirectory"
    fi

    if [ $# -ge 1 ]; then
        info "$1が指定されました。$1ブランチで実行します。"
        git checkout $1
        git pull --rebase
    fi

    mkdir -p "$HOME/.config"

    # git
    mkdir -p ~/Development
    create_symbolic "$dotfilesDirectory/git/.gitconfig" "$HOME/.gitconfig"
    create_symbolic "$dotfilesDirectory/git/.gitconfig_users" "$HOME/.gitconfig_users"

    # homebrew
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    cat "$dotfilesDirectory/homebrew/Brewfiles_all" > "$dotfilesDirectory/homebrew/Brewfiles"
    if [ $(uname -s) -eq "Darwin" ] {
        info "実行環境がMacのため、cask経由でアプリケーションをインストールします。"
        cat "$dotfilesDirectory/homebrew/Brewfiles_mac" >> "$dotfilesDirectory/homebrew/Brewfiles"
    }
    brew bundle --file "$dotfilesDirectory/homebrew/Brewfiles"

    # fish / fisher
    create_symbolic "$dotfilesDirectory/fish" "$HOME/.config/fish"
    fish -c "curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher"

    #tmux / tpm
    create_symbolic "$dotfilesDirectory/tmux/.tmux.conf" "$HOME/.tmux.conf"
    git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
}

main
