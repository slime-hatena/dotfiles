function _fzf_cd_ghq() {
  local root="$(ghq root)"
  local repo="$(ghq list | ${INTERACTIVE_FILTER} --preview="ls -AF --color=always ${root}/{1}")"
  local dir="${root}/${repo}"
  [ -n "${dir}" ] && cd "${dir}"
  zle accept-line
  zle reset-prompt
}

zle -N _fzf_cd_ghq
