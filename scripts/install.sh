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
    mkdir -p "$HOME/Development"
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
        diff "${dotfilesDirectory}/bash/.profile" "${HOME}/.profile" >/dev/null 2>&1
        if [ $? -eq 1 ]; then
            info "$HOME/.profile を ${dotfilesDirectory}/bash/.profile の内容で上書きします。"
            backup "$HOME/.profile"
            cp "${dotfilesDirectory}/bash/.profile" "${HOME}/.profile"
        fi
    else
        info "$HOME/.profile を作成します。"
        cp "${dotfilesDirectory}/bash/.profile" "${HOME}/.profile"
    fi

    if [ -f "$HOME/.bashrc" ]; then
        diff "${dotfilesDirectory}/bash/.bashrc" "${HOME}/.bashrc" >/dev/null 2>&1
        if [ $? -eq 1 ]; then
            info "$HOME/.bashrc を ${dotfilesDirectory}/bash/.bashrc の内容で上書きします。"
            backup "$HOME/.bashrc"
            cp "${dotfilesDirectory}/bash/.bashrc" "${HOME}/.bashrc"
        fi
    else
        info "$HOME/.bashrc を作成します。"
        cp "${dotfilesDirectory}/bash/.bashrc" "${HOME}/.bashrc"
    fi

    # if [ "$(grep $USER /etc/passwd | cut -d: -f7)" != "/bin/bash" ]; then
    #     info "ログインシェルを /bin/bash に変更します。"
    #     chsh -s /bin/bash
    # fi

    # homebrew
    if ! exists brew; then
        info "homebrewをインストールします。"

        if [ "$(uname -m)" == 'aarch64' ]; then
            info "実行環境がARMのため、直接導入します。"

            sudo apt update
            sudo apt upgrade -y
            sudo apt install -y build-essential procps curl file git gcc

            mkdir -p ~/.cache/Homebrew
            cd ~/.cache/Homebrew
            wget https://github.com/Homebrew/homebrew-portable-ruby/releases/download/2.6.3/portable-ruby-2.6.3.aarch64_linux.bottle.tar.gz

            sudo mkdir -p /home/linuxbrew/.linuxbrew/Library/Homebrew/vendor
            cd /home/linuxbrew/.linuxbrew/Library/Homebrew/vendor
            sudo tar -zxvf ~/.cache/Homebrew/portable-ruby-2.6.3.aarch64_linux.bottle.tar.gz
            cd portable-ruby
            sudo ln -sf 2.6.3 current
            echo 'export PATH=/home/linuxbrew/.linuxbrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH' >>$HOME/.bash_path
            export PATH=/home/linuxbrew/.linuxbrew/Library/Homebrew/vendor/portable-ruby/current/bin:$PATH
            which ruby
            ruby -v

            sudo git clone https://github.com/Homebrew/brew /home/linuxbrew/.linuxbrew/Homebrew
            sudo mkdir /home/linuxbrew/.linuxbrew/bin
            sudo ln -s /home/linuxbrew/.linuxbrew/Homebrew/bin/brew /home/linuxbrew/.linuxbrew/bin
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.bash_path
            eval $(/home/linuxbrew/.linuxbrew/bin/brew shellenv)

            sudo chown -R $(whoami):$(whoami) /home/linuxbrew/.linuxbrew
            which brew
            brew -v

            cd $dotfilesDirectory

        else
            /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install.sh)"

            info "homebrewにパスを通します。"
            if [ "$(uname)" == 'Darwin' ]; then
                echo 'export PATH=/usr/local/bin:$PATH' >>$HOME/.bash_path
            else
                if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
                    echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.bash_path
                    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
                fi

                if [ -f "$HOME/.linuxbrew/bin/brew" ]; then
                    echo "eval \"$($HOME/.linuxbrew/bin/brew shellenv)\"" >>$HOME/.bash_path
                    eval "$($HOME/.linuxbrew/bin/brew shellenv)"
                fi
            fi
        fi
    fi

    info "brewfileに記載されているパッケージを導入します。"
    cat "$dotfilesDirectory/homebrew/min/Brewfiles_all" >"$dotfilesDirectory/homebrew/Brewfiles"
    if [ "$(uname)" == 'Darwin' ]; then
        info "実行環境がMacのため、cask経由でアプリケーションをインストールします。"
        cat "$dotfilesDirectory/homebrew/min/Brewfiles_mac" >>"$dotfilesDirectory/homebrew/Brewfiles"
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
        git checkout $dotfilesDirectory/fish/fish_plugins

        info "fisherのプラグインを追加します。"
        $(which fish) -c "fisher update"
    else
        error "fishがインストールされていません。"
    fi

    # hyper
    info ".hyper.jsを追加します。"
    create_symbolic "$dotfilesDirectory/hyper/.hyper.js" "$HOME/.hyper.js"

    # kitty
    info "kitty.confを追加します。"
    create_symbolic "$dotfilesDirectory/kitty/kitty.conf" "$HOME/.config/kitty/kitty.conf"

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
        chmod 777 "$HOME/tmuximum/tmuximum"
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
    error "homebrewのインストールに失敗しました。何らかの不具合が起きている可能性があります。"
else
    brew doctor
fi

if ! exists fish; then
    error "fishのインストールに失敗しました。何らかの不具合が起きている可能性があります。"
fi

cd $HOME
exec /bin/bash -l
