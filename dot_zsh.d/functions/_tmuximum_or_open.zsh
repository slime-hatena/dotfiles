function _tmuximum_or_open {
  if [ -z "$TMUX" ]; then
    BUFFER="tmux new-session -A -s \"${TERM}\""
    zle accept-line
    zle reset-prompt
  else
    BUFFER="tmuximum"
    zle accept-line
    zle reset-prompt
  fi
}

zle -N _tmuximum_or_open
