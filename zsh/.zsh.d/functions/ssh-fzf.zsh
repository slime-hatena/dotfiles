function ssh-fzf () {
  local selected_host
  selected_host=`cat ~/.ssh/config | grep -i ^host | awk '{print $2}' | fzf`

  if [ -n "selected_host" ]; then
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N ssh-fzf
