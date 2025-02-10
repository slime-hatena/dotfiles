# slime-hatena/dotfiles/ssh

[ssh](https://www.openssh.com/)

## install

```sh { name=ssh-install }
mkdir -p ~/.ssh
ln -nfs ~/.dotfiles/env/ssh/config ~/.ssh/config
ln -nfs ~/.dotfiles/env/ssh/conf.d ~/.ssh/conf.d
touch ~/.ssh/local_settings
mkdir -p ~/.ssh/keys
mkdir -p ~/.ssh/keys/public
```
