# slime-hatena/dotfiles/git

[git](https://git-scm.com/)

## install

```sh { name=git-install }
mkdir -p ${XDG_CONFIG_HOME}/git
ln -nfs ~/.dotfiles/env/git/.gitconfig ${XDG_CONFIG_HOME}/git/config

if [ ! -e ~/.gitconfig_users ]; then
  cp ~/.dotfiles/env/git/.gitconfig_users.example ${XDG_CONFIG_HOME}/git/.gitconfig_users
  echo "Next you should edit ${XDG_CONFIG_HOME}/git/.gitconfig_users."
fi
```
