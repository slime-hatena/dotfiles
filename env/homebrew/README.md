# slime-hatena/dotfiles/homebrew

[Homebrew](https://brew.sh/ja/)

## install

Brewfileに記載されているパッケージをインストールします。
先に下の`brew-install-min`などを実行して、Brewfileを作成しておく必要があります。

```sh { name=brew-install-bundle }
brew bundle --file="./Brewfile"
```

### all

min, dev, extraの全てのアプリケーションをインストールします。

```sh { name=brew-prepare-all }
echo "> runme run brew-install-min"
runme run brew-prepare-min
echo "" >>"./Brewfile"
cat "./Brewfile" >"./Brewfile.tmp"

echo "> runme run brew-install-dev"
runme run brew-prepare-dev
echo "" >>"./Brewfile"
cat "./Brewfile" >>"./Brewfile.tmp"

echo "> runme run brew-install-extra"
runme run brew-prepare-extra
cat "./Brewfile" >>"./Brewfile.tmp"

mv ./Brewfile.tmp ./Brewfile

echo ""
echo "Next, run 'runme run brew-install-bundle' command."
```

### min

このdotfiles環境を動かす最低限のアプリケーションをBrewfileに記載します。

```sh { name=brew-prepare-min }
cat "./min/Brewfile" >"./Brewfile"
if [ "$(uname)" == 'Darwin' ]; then
    echo "" >>"./Brewfile"
    cat "./min/Brewfile.mac" >>"./Brewfile"
fi
```

### dev

開発に必要なアプリケーションをBrewfileに記載します。

```sh { name=brew-prepare-dev }
cat "./dev/Brewfile" >"./Brewfile"
if [ "$(uname)" == 'Darwin' ]; then
    echo "" >>"./Brewfile"
    cat "./dev/Brewfile.mac" >>"./Brewfile"
fi
```

### extra

遊びや趣味に関連するアプリケーションをBrewfileに記載します。

```sh { name=brew-prepare-extra }
cat "./extra/Brewfile" >"./Brewfile"
if [ "$(uname)" == 'Darwin' ]; then
    echo "" >>"./Brewfile"
    cat "./extra/Brewfile.mac" >>"./Brewfile"
fi
```

## update

ローカルにインストールされているBrewパッケージからこのdotfilesに含まれていないものを列挙します。

```sh  { name=brew-listup-untracked-packages }
brew bundle dump --force
mv Brewfile Brewfile.local
sed -i '' '/^vscode /d' Brewfile.local

cat "./Brewfile.local" >"./Brewfile.all"
cat "./min/Brewfile" >>"./Brewfile.all"
cat "./min/Brewfile.mac" >>"./Brewfile.all"
cat "./dev/Brewfile" >>"./Brewfile.all"
cat "./dev/Brewfile.mac" >>"./Brewfile.all"
cat "./extra/Brewfile" >>"./Brewfile.all"
cat "./extra/Brewfile.mac" >>"./Brewfile.all"
sed -i '' '/^\# /d' ./Brewfile.all

sort ./Brewfile.all | uniq -u >./Brewfile.untracked
rm ./Brewfile.all
code ./Brewfile.untracked
```
