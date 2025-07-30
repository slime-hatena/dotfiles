# slime-hatena/dotfiles/WezTerm

[WezTerm](https://wezfurlong.org/wezterm/)

## install

```sh { name=wezterm-install }
tempfile=$(mktemp) \
  && curl -o $tempfile https://raw.githubusercontent.com/wezterm/wezterm/main/termwiz/data/wezterm.terminfo \
  && tic -x -o ~/.terminfo $tempfile \
  && rm $tempfile

mkdir -p ${XDG_CONFIG_HOME}/wezterm/
ln -nfs ~/.dotfiles/env/wezterm/wezterm.lua ${XDG_CONFIG_HOME}/wezterm/wezterm.lua
ln -nfs ~/.dotfiles/env/wezterm/keybinds.lua ${XDG_CONFIG_HOME}/wezterm/keybinds.lua
```
