#!/bin/bash
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
###    install                                                                             ###
###========================================================================================###

install() {
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/Development/github.com/Slime-hatena"

    info "ghqの管理ディレクトリにdotfilesのシンボリックリンクを作成します。"
    create_symbolic "$dotfilesDirectory" "$HOME/Development/github.com/Slime-hatena/dotfiles"

    # homebrew
    info "homebrewをインストールします。"
    if ! exists brew; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"
    else
        info "homebrewはインストール済みのためスキップします。"
    fi

    info "brewfileに記載されているパッケージを導入します。"
    cat "$dotfilesDirectory/homebrew/Brewfiles_all" > "$dotfilesDirectory/homebrew/Brewfiles"
    if [ "$(uname)" == 'Darwin' ]; then
        info "実行環境がMacのため、cask経由でアプリケーションをインストールします。"
        cat "$dotfilesDirectory/homebrew/Brewfiles_mac" >> "$dotfilesDirectory/homebrew/Brewfiles"
    fi
    brew bundle --file "$dotfilesDirectory/homebrew/Brewfiles"

    # git
    info ".gitconfigを追加します。"
    create_symbolic "$dotfilesDirectory/git/.gitconfig" "$HOME/.gitconfig"
    create_symbolic "$dotfilesDirectory/git/.gitconfig_users" "$HOME/.gitconfig_users"

    # fish / fisher
    if exists brew; then
        info "fishの設定ファイルを追加します。"
        create_symbolic "$dotfilesDirectory/fish" "$HOME/.config/fish"
        info "fisherをインストールします。"
        $(which fish) -c "curl -sL git.io/fisher | source && fisher install jorgebucaran/fisher"
    else
        error "fishがインストールされていません。"
    fi


    #tmux / tpm
    info "tmuxの設定ファイルを追加します。"
    create_symbolic "$dotfilesDirectory/tmux/.tmux.conf" "$HOME/.tmux.conf"
    if [ -d "$HOME/.tmux/plugins/tpm" ]; then
        info "tpmを更新します。"
        cd "$HOME/.tmux/plugins/tpm"
        git pull --rebase
        cd "$dotfilesDirectory"
    else
        info "tpmが存在しないため、cloneします。"
        git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
    fi

    info "インストールが完了しました！"
}

install
