#!/bin/bash
set -u

dotfilesDirectory=$HOME/.dotfiles
defaultShell="/bin/bash"
userName=$(whoami)

. "$dotfilesDirectory/scripts/_functions.sh"

###========================================================================================###
###    install                                                                             ###
###========================================================================================###

install() {
    # 必要なディレクトリ類の作成
    mkdir -p "$HOME/.config"
    mkdir -p "$HOME/Development"
    touch "$HOME/.bash_path"

    # 既存ファイルの退避
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

    # .profileが存在しなければ作成 / 存在すれば退避して上書き
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

    # .bashrcが存在しなければ作成 / 存在すれば退避して上書き
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

    # Homebrewのインストール
    if ! exists brew; then
        info "Homebrewをインストールします。"

        info "sudoセッションを作成します。"
        sudo echo "create" >/dev/null
        if [ $? -ne 0 ] ; then
            error "作成に失敗しました。"
            exit 1
        fi

        info "作成に成功しました！"
        sleep 1

        NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

        info "Homebrewにパスを通します。"
        if isMac; then
            echo 'export PATH="/opt/homebrew/bin:$PATH"' >>$HOME/.bash_path
        else # Linux
            echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >>$HOME/.bash_path
            eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

            info "必要なパッケージをapt経由でインストールします。"
            sudo apt update
            sudo apt install -y build-essential
        fi
    else
        info "Homebrewはインストール済みのためスキップします。"
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
    if ! exists brew; then
        error "Homebrewが存在しません。何らかの不具合が起きている可能性があります。"
        exit 1
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
    # ログインシェルの変更
    if isMac; then
        if [ "$(dscl localhost -read Local/Default/Users/${userName} UserShell | cut -d' ' -f2)" != "${defaultShell}" ]; then
            info "ログインシェルを ${defaultShell} に変更します。"
            sudo chsh -s ${defaultShell} ${userName}
        fi
    else
        error "fishがインストールされていません。"
        if [ "$(grep ${userName} /etc/passwd | cut -d: -f7)" != "${defaultShell}" ]; then
            info "ログインシェルを ${defaultShell} に変更します。"
            chsh -s ${defaultShell}
        fi
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
