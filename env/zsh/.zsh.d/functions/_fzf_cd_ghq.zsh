function _fzf_cd_ghq_with_git_fzf() {
  local root="$(ghq root)"
  local repo=$(ghq list | _fzf_git_fzf --ansi \
    --border-label ' 📂 Directories ' \
    --tiebreak begin \
    --preview-window down,border-top,40% \
    --color hl:underline,hl+:underline \
    --no-hscroll \
    --preview "ls -AF --color=always ${root}/{}"
  )

  if [ -n "$repo" ]; then
    local dir="${root}/${repo}"
    BUFFER="cd ${dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N _fzf_cd_ghq_with_git_fzf

function _fzf_cd_ghq() {
  local root="$(ghq root)"
  local repo="$(ghq list | ${INTERACTIVE_FILTER} --preview="ls -AF --color=always ${root}/{1}")"
  if [ -n "$repo" ]; then
    local dir="${root}/${repo}"
    BUFFER="cd ${dir}"
    zle accept-line
  fi
  zle reset-prompt
}
zle -N _fzf_cd_ghq
