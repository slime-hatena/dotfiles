function _fzf_ssh(){
  local selected_host
  selected_host=`cat ~/.ssh/config ~/.ssh/conf.d/** | grep -i ^host | grep -v "*"| grep -v "ignore" | awk '{print $2}' | fzf`

  if [ -n "$selected_host" ]; then
    # if echo "$selected_host" | grep -q "prod"; then
    #   tmux select-pane -P 'bg=colour009,fg=white'
    # fi
    BUFFER="ssh ${selected_host}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N _fzf_ssh
