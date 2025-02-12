# slime-hatena/dotfiles/git

[git](https://git-scm.com/)

## install

```sh { name=git-install }
ln -nfs ~/.dotfiles/env/git/.gitconfig ~/.gitconfig

if [ ! -e ~/.gitconfig_users ]; then
  cp ~/.dotfiles/env/git/.gitconfig_users.example ~/.gitconfig_users
  echo "Next you should edit ~/.gitconfig_users."
fi
```
