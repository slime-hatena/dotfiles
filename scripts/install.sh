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

### ファイルをバックアップフォルダに移動します。
backup() {
    filename=$(basename $1).$(date +%s)
    mkdir -p "${dotfilesDirectory}/backup"
    mv "$1" "${dotfilesDirectory}/backup/${filename}"
    info "${1}を${filename}に移動しました。"
}

### ファイルが存在する場合は待避し、シンボリックリンクを作成します。
create_symbolic() {
    info "${1} → ${2} のシンボリックリンクを作成します。"
    if [ -e "$2" ]; then
        if [ -L "$2" ]; then
            warn "シンボリックリンクが存在します。削除します。"
            rm "$2"
        else
            backup $2
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
    touch "$HOME/.bash_path"

    if [ -f "$HOME/.bash_profile" ]; then
        if ! ask_yes_or_no "$HOME/.bash_profile が存在すると正常に動作しない可能性があります。退避しますか？"; then
            warn "キャンセルしました。正常に動作しない場合は手動で退避してください。"
        else
            backup "$HOME/.bash_profile"
        fi
    fi

    if [ -f "$HOME/.bash_login" ]; then
        if ! ask_yes_or_no "$HOME/.bash_login が存在すると正常に動作しない可能性があります。退避しますか？"; then
            warn "キャンセルしました。正常に動作しない場合は手動で退避してください。"
        else
            backup "$HOME/.bash_login"
        fi
    fi

    if [ -f "$HOME/.profile" ]; then
        info "$HOME/.profile を ${dotfilesDirectory}/bash/.profile の内容で上書きします。"
        backup "$HOME/.profile"
        cp "${dotfilesDirectory}/bash/.profile" "${HOME}/.profile"
    fi

    info "ghqの管理ディレクトリにdotfilesのシンボリックリンクを作成します。"
    create_symbolic "$dotfilesDirectory" "$HOME/Development/github.com/Slime-hatena/dotfiles"

    # homebrew
    if ! exists brew; then
        info "homebrewをインストールします。"
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

        info "homebrewにパスを通します。"
        if [ "$(uname)" == 'Darwin' ]; then
            echo 'export PATH=/usr/local/bin:$PATH' >>$HOME/.bash_path
        else
            if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
                echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.bash_path
                eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
            fi

            if [ -f "$HOME-hatena/.linuxbrew/bin/brew" ]; then
                echo 'eval "$(/home/slime-hatena/.linuxbrew/bin/brew shellenv)"' >>$HOME/.bash_path
                eval "$($HOME/.linuxbrew/bin/brew shellenv)"
            fi
        fi
    fi

    info "brewfileに記載されているパッケージを導入します。"
    cat "$dotfilesDirectory/homebrew/Brewfiles_all" >"$dotfilesDirectory/homebrew/Brewfiles"
    if [ "$(uname)" == 'Darwin' ]; then
        info "実行環境がMacのため、cask経由でアプリケーションをインストールします。"
        cat "$dotfilesDirectory/homebrew/Brewfiles_mac" >>"$dotfilesDirectory/homebrew/Brewfiles"
    fi
    brew bundle --file "$dotfilesDirectory/homebrew/Brewfiles"

    # git
    info ".gitconfigを追加します。"
    create_symbolic "$dotfilesDirectory/git/.gitconfig" "$HOME/.gitconfig"
    if [ ! -f $HOME/.gitconfig_users ]; then
        info "$HOME/.gitconfig_users を作成しました。gitのユーザー情報を書き込んでください。"
        cp "$dotfilesDirectory/git/.gitconfig_users.example" "$HOME/.gitconfig_users"
    fi

    # fish / fisher
    if exists fish; then
        info "fisherをインストールします。"
        $(which fish) -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"

        info "fishの設定ファイルを追加します。"
        create_symbolic "$dotfilesDirectory/fish" "$HOME/.config/fish"

        info "fisherのプラグインを追加します。"
        $(which fish) -c "fisher update"
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

    if [ -d "$HOME/tmuximum" ]; then
        info "tmuximumを更新します。"
        cd "$HOME/tmuximum"
        git checkout .
        git pull --rebase
        cd "$dotfilesDirectory"
    else
        info "tmuximumが存在しないため、インストールします。"
        curl -L https://raw.github.com/arks22/tmuximum/master/install.bash | bash
        chmod 777 "$HOME/tmuximum/tmuximum"
        echo "export PATH=$HOME/tmuximum:"'$PATH' >>~/.bash_path
        export PATH=$HOME/tmuximum:$PATH
    fi

    info "インストールが完了しました！"
}

install

if ! exists brew; then
    error "fishのインストールに失敗したため実行できませんでした。何らかの不具合が起きている可能性があります。"
fi

cd $HOME
exec /bin/bash -l
