# slime-hatena/dotfiles/tmux

[tmux](https://github.com/tmux/tmux/wiki)  
[tpm](https://github.com/tmux-plugins/tpm)  
[tmuximum](https://github.com/arks22/tmuximum)

## install

```sh { name=tmux-install }
if [ -d "$HOME/tmuximum" ]; then
  cd "$HOME/tmuximum"
  git reset --hard origin/$(git symbolic-ref --short HEAD)
  chmod 777 "$HOME/tmuximum/tmuximum"
  cd ~/.dotfiles
else
  curl -L https://raw.github.com/arks22/tmuximum/master/install.bash | bash
  chmod 777 "$HOME/tmuximum/tmuximum"
fi

if [[ ":$PATH:" != *":$HOME/tmuximum:"* ]]; then
  echo "export PATH=\"\$PATH:\$HOME/tmuximum\"" >> "$HOME/.bash_path"
  export PATH="$PATH:$HOME/tmuximum"
fi

ln -nfs ~/.dotfiles/env/tmux/.tmux.conf ~/.tmux.conf
```
