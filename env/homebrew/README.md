# slime-hatena/dotfiles/homebrew

[Homebrew](https://brew.sh/ja/)

## install

Brewfileに記載されているパッケージをインストールします。
先に下の`brew-init-all`などを実行して、Brewfileを作成しておく必要があります。

```bash { name=brew-install }
brew bundle --file="./Brewfile" -v
```

## init bundle

Brewfileを作成します。  
実行前に `./Brewfile` を削除してください。

```bash { name=brew-init }
rm -f ./Brewfile
```

### min

```bash { name=brew-add-min }
cat "./min/Brewfile" >>"./Brewfile"
```

### min mac applications

```bash { name=brew-add-min-mac }
cat "./min/Brewfile.mac" >>"./Brewfile"
```

### dev

```bash { name=brew-add-dev }
cat "./dev/Brewfile" >>"./Brewfile"
```

### dev mac applications

```bash { name=brew-add-extra-mac }
cat "./dev/Brewfile.mac" >>"./Brewfile"
```

### extra

```bash { name=brew-add-extra }
cat "./extra/Brewfile" >>"./Brewfile"
```

### extra mac applications

```bash { name=brew-add-extra-mac }
cat "./extra/Brewfile.mac" >>"./Brewfile"
```

## update

ローカルにインストールされているBrewパッケージからこのdotfilesに含まれていないものを列挙します。

```bash  { name=brew-listup-untracked-packages }
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
