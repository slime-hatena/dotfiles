INTERACTIVE_FILTER="fzf-tmux"

# macOS: enable ^q ^s etc...
setopt no_flow_control

setopt GLOB_SUBST
setopt HIST_IGNORE_DUPS
setopt HIST_IGNORE_SPACE
setopt INC_APPEND_HISTORY
setopt HIST_EXPIRE_DUPS_FIRST
setopt SHARE_HISTORY

DISABLE_AUTO_TITLE="true"

export LSCOLORS=cxfxcxdxbxegedabagacad
alias ls='ls -GF'
alias rm='trash'

export FZF_DEFAULT_OPTS='--height 40% --reverse --select-1'

export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#c6c6c6,bg=#106a84,bold,underline"

