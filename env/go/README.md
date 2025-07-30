# slime-hatena/dotfiles/go

[Go](https://go.dev/)

## install

```sh { name=go-install }

go install github.com/pocke/get@latest
mkdir -p ${XDG_CONFIG_HOME}/get
ln -nfs ~/.dotfiles/env/go/get/args ${XDG_CONFIG_HOME}/get/args
```
