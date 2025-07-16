# slime-hatena/dotfiles/go

[Go](https://go.dev/)

## install

```sh { name=go-install }

# pathに $GOPATH/bin が含まれるかをチェック なければpath追加
if [[ ":$PATH:" != *":$GOPATH/bin:"* ]]; then
  echo "export PATH=\"\$PATH:\$GOPATH/bin\"" >> "$HOME/.bash_path"
  export PATH="$PATH:$GOPATH/bin"
fi
```
