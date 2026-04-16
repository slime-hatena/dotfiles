# slime-hatena/dotfiles

[![Latest version](https://img.shields.io/github/v/release/slime-hatena/dotfiles?style=for-the-badge)](https://github.com/slime-hatena/dotfiles/releases/latest)

🍮こんな環境で作業しています

## Install

chezmoiを使用してセットアップされています。

```sh
sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply slime-hatena
```

### brew install packages

`chezmoi apply` 実行時に `~/.config/homebrew/Brewfile` の内容が自動的にインストールされます。
開発用パッケージ (php/hugo 等) や追加パッケージ (ffmpeg/yt-dlp 等) は初回プロンプトで選択します。
