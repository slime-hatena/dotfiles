# slime-hatena/dotfiles/tmux

[tmux](https://github.com/tmux/tmux/wiki)  
[tpm](https://github.com/tmux-plugins/tpm)  
[tmuximum](https://github.com/arks22/tmuximum)

## install

```sh { name=tmux-install }
if [ -d "$HOME/.tmux/plugins/tpm" ]; then
  cd "$HOME/.tmux/plugins/tpm"
  git reset --hard origin/$(git symbolic-ref --short HEAD)
  cd ~/.dotfiles
else
  info "tpmが存在しないため、cloneします。"
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if [ -d "$HOME/tmuximum" ]; then
  cd "$HOME/tmuximum"
  git reset --hard origin/$(git symbolic-ref --short HEAD)
  chmod 777 "$HOME/tmuximum/tmuximum"
  cd ~/.dotfiles
else
  curl -L https://raw.github.com/arks22/tmuximum/master/install.bash | bash
  chmod 777 "$HOME/tmuximum/tmuximum"
  echo "export PATH=$HOME/tmuximum:"'$PATH' >>~/.bash_path
  export PATH=$HOME/tmuximum:$PATH
fi

ln -nfs ~/.dotfiles/env/tmux/.tmux.conf ~/.tmux.conf
```
