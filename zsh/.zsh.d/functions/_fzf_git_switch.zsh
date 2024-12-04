# https://www.mizdra.net/entry/2024/10/19/172323

_fzf_git_branch_user_name=$(git config user.name)
_fzf_git_branch_fmt="\
%(if:equals=$_fzf_git_branch_user_name)%(authorname)%(then)%(color:default)%(else)%(color:brightred)%(end)%(refname:short)|\
%(committerdate:relative)|\
%(subject)"

function _fzf_git_branch() {
  if git rev-parse --is-inside-work-tree &>/dev/null; then
    selected_branch=$(
      git branch --sort=-committerdate --format=$_fzf_git_branch_fmt --color=always \
      | column -ts'|' \
      | fzf --height 99% --no-sort --no-hscroll --preview-window=down --ansi --exact --preview='git log --oneline --graph --decorate --color=always -50 {+1}' \
      | awk '{print $1}' \
    )
    if [ -n "${selected_branch}" ]; then
      BUFFER="git switch ${selected_branch}"
      zle accept-line
    fi
    zle reset-prompt
  else
    echo "Current directory is not a git repository."
    sleep 0.5
    zle reset-prompt
  fi
}

zle -N _fzf_git_branch
