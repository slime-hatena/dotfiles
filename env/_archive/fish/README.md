# slime-hatena/dotfiles/fisher

[fish](https://fishshell.com/)  
[fisher](https://github.com/jorgebucaran/fisher)

## install

```sh { name=fish-install }
$(which fish) -c "curl -sL https://git.io/fisher | source && fisher install jorgebucaran/fisher"
ln -nfs ~/.dotfiles/env/fish ~/.config/fish
git checkout ~/.dotfiles/env/fish/fish_plugins
$(which fish) -c "fisher update"
```
