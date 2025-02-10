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

  runme run brew-prepare-min
  runme run brew-install
  runme run bash-install
  runme run git-install
  runme run nvim-install
  runme run ssh-install
  runme run tmux-install
  runme run wezterm-install
}

main
