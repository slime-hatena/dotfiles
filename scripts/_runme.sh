#!/bin/bash
set -u

. "$dotfilesDirectory/scripts/_functions.sh"

main() {
  info "brew経由でrunmeをインストールします。"
  brew install runme

  if ! exists runme; then
    error "runmeが存在しません。何らかの不具合が起きている可能性があります。"
    exit 1
  fi

  info "各README.mdに記載されているインストールスクリプトを実行します。"

  info "Homebrew経由で最低限のパッケージをインストールします。"
  runme run brew-init
  runme run brew-add-min
  if isMac; then
    runme run brew-add-min-mac
  fi
  runme run brew-install

  info "bashの設定ファイルを配置します。"
  runme run bash-install

  info "gitの設定ファイルを配置します。"
  runme run git-install

  info "nvimの設定ファイルを配置します。"
  runme run nvim-install

  info "sshの設定ファイルを配置します。"
  runme run ssh-install

  info "tmuxの設定ファイルを配置します。"
  runme run tmux-install

  info "weztermの設定ファイルを配置します。"
  runme run wezterm-install

  info "zshの設定ファイルを配置します。"
  runme run zsh-install
}

main
