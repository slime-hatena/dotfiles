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

```bash { name=brew-add-dev-mac }
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
sed -i '' '/^vscode /d' Brewfile
sort Brewfile > Brewfile.local
rm Brewfile

echo "" > ./tmp
cat "./min/Brewfile" >>"./tmp"
cat "./min/Brewfile.mac" >>"./tmp"
cat "./dev/Brewfile" >>"./tmp"
cat "./dev/Brewfile.mac" >>"./tmp"
cat "./extra/Brewfile" >>"./tmp"
cat "./extra/Brewfile.mac" >>"./tmp"
sed -i '' '/^\# /d' ./tmp
sed -i '' '/^$/d' ./tmp
sort tmp > ./Brewfile.all
rm tmp

code --diff ./Brewfile.all ./Brewfile.local
```
