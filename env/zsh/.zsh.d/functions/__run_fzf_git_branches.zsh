function __run_fzf_git_branches {
  local selected
  selected=`_fzf_git_branches`

  if [ -n "$selected" ]; then
    BUFFER="git switch ${selected}"
    zle accept-line
  fi
  zle reset-prompt
}

zle -N __run_fzf_git_branches
